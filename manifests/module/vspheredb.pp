# @summary Installs the vsphereDB plugin
#
# @param [Enum['absent', 'present']] ensure
#   Ensur es the state of the vspheredb module.
#
# @param [String] git_repository
#   The upstream module repository.
#
# @param [Optional[String]] git_revision
#   The version of the module that needs to be used.
#
# @param [Enum['git', 'none', 'package']] install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param [String] package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param [Enum['mysql']] db_type
#   The database type. Either mysql or postgres.
#
# @param [Optional[Stdlib::Host]] db_host
#   The host where the vspheredb-database will be running
#
# @param [Stdlib::Port] db_port
#   The port on which the database is accessible.
#
# @param [Optional[String]] db_name
#   The name of the database this module should use.
#
# @param [Optional[String]] db_username
#   The username needed to access the database.
#
# @param [Optional[String]] db_password
#   The password needed to access the database.
#
# @param [String] db_charset
#   The charset the database is set to.
#
# @param [Boolean] import_schema
#   Whether to import the database schema or not.
#
# @example
#   class { 'icingaweb2::module::vspheredb':
#     ensure       => 'present',
#     git_revision => 'v1.1.0',
#     db_host      => 'localhost',
#     db_name      => 'vspheredb',
#     db_username  => 'vspheredb',
#     db_password  => 'supersecret',
#   }
#
class icingaweb2::module::vspheredb (
  Enum['absent', 'present']      $ensure         = 'present',
  String                         $git_repository = 'https://github.com/Icinga/icingaweb2-module-vspheredb.git',
  Optional[String]               $git_revision   = undef,
  Enum['git', 'none', 'package'] $install_method = 'git',
  String                         $package_name   = 'icingaweb2-module-vspheredb',
  Enum['mysql']                  $db_type        = 'mysql',
  Optional[Stdlib::Host]         $db_host        = undef,
  Stdlib::Port                   $db_port        = 3306,
  Optional[String]               $db_name        = undef,
  Optional[String]               $db_username    = undef,
  Optional[String]               $db_password    = undef,
  String                         $db_charset     = 'utf8mb4',
  Boolean                        $import_schema  = false,
) {
  $conf_dir               = $::icingaweb2::globals::conf_dir
  $mysql_vspheredb_schema = $::icingaweb2::globals::mysql_vspheredb_schema
  $module_conf_dir        = "${conf_dir}/modules/vspheredb"

  icingaweb2::config::resource { 'icingaweb2-module-vspheredb':
    type        => 'db',
    db_type     => $db_type,
    host        => $db_host,
    port        => $db_port,
    db_name     => $db_name,
    db_username => $db_username,
    db_password => $db_password,
    db_charset  => $db_charset,
  }

  icingaweb2::module { 'vspheredb':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    package_name   => $package_name,
    settings       => {
      'icingaweb2-module-vspheredb' => {
        'section_name' => 'db',
        'target'       => "${module_conf_dir}/config.ini",
        'settings'     => {
          'resource' => 'icingaweb2-module-vspheredb',
        },
      },
    },
  }

  if $import_schema {
    case $db_type {
      'mysql': {
        exec { 'import vspheredb schema':
          user    => 'root',
          path    => $::facts['path'],
          command => "mysql -h '${db_host}' -P '${db_port}' -u '${db_username}' -p'${db_password}' '${db_name}' < '${mysql_vspheredb_schema}'",
          unless  => "mysql -h '${db_host}' -P '${db_port}' -u '${db_username}' -p'${db_password}' '${db_name}' -Ns -e 'SELECT schema_version FROM vspheredb_schema_migration'",
          require => Icingaweb2::Module['vspheredb'],
        }
      }
      default: {
        fail('The database type you provided is not supported.')
      }
    }
  }

}
