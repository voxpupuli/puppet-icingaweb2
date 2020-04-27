# @summary
#   Installs and configures the director module.
#
# @param [Enum['absent', 'present']] ensure
#   Enable or disable module.
#
# @param [String] git_repository
#   Set a git repository URL.
#
# @param [Optional[String]] git_revision
#   Set either a branch or a tag name, eg. `master` or `v1.3.2`.
#
# @param [Enum['mysql', 'pgsql']] db_type
#   Type of your database. Either `mysql` or `pgsql`.
#
# @param [Stdlib::Host] db_host
#   Hostname of the database.
#
# @param [Stdlib::Port] db_port
#   Port of the database.
#
# @param [Optional[String]] db_name
#   Name of the database.
#
# @param [Optional[String]] db_username
#   Username for DB connection.
#
# @param [Optional[String]] db_password
#   Password for DB connection.
#
# @param [Boolean] import_schema
#   Import database schema.
#
# @param [Boolean] kickstart
#   Run kickstart command after database migration. This requires `import_schema` to be `true`.
#
# @param [Optional[String]] endpoint
#   Endpoint object name of Icinga 2 API. This setting is only valid if `kickstart` is `true`.
#
# @param [Stdlib::Host] api_host
#   Icinga 2 API hostname. This setting is only valid if `kickstart` is `true`.
#
# @param [Stdlib::Port] api_port
#   Icinga 2 API port. This setting is only valid if `kickstart` is `true`.
#
# @param [Optional[String]] api_username
#   Icinga 2 API username. This setting is only valid if `kickstart` is `true`.
#
# @param [Optional[String]] api_password
#   Icinga 2 API password. This setting is only valid if `kickstart` is `true`.
#
# @note Please checkout the [Director module documentation](https://www.icinga.com/docs/director/latest/) for requirements.
#
# @example
#   class { 'icingaweb2::module::director':
#     git_revision  => 'v1.7.2',
#     db_host       => 'localhost',
#     db_name       => 'director',
#     db_username   => 'director',
#     db_password   => 'supersecret',
#     import_schema => true,
#     kickstart     => true,
#     endpoint      => 'puppet-icingaweb2.localdomain',
#     api_username  => 'director',
#     api_password  => 'supersecret',
#     require       => Mysql::Db['director']
#   }
#
class icingaweb2::module::director(
  String                    $git_repository,
  Enum['absent', 'present'] $ensure         = 'present',
  Optional[String]          $git_revision   = undef,
  Enum['mysql', 'pgsql']    $db_type        = 'mysql',
  Stdlib::Host              $db_host        = undef,
  Stdlib::Port              $db_port        = 3306,
  Optional[String]          $db_name        = undef,
  Optional[String]          $db_username    = undef,
  Optional[String]          $db_password    = undef,
  String                    $db_charset     = 'utf8',
  Boolean                   $import_schema  = false,
  Boolean                   $kickstart      = false,
  Optional[String]          $endpoint       = undef,
  Stdlib::Host              $api_host       = 'localhost',
  Stdlib::Port              $api_port       = 5665,
  Optional[String]          $api_username   = undef,
  Optional[String]          $api_password   = undef,
) {

  $conf_dir        = $::icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/director"

  Exec {
    user => 'root',
    path => $::path,
  }

  icingaweb2::config::resource { 'icingaweb2-module-director':
    type        => 'db',
    db_type     => $db_type,
    host        => $db_host,
    port        => $db_port,
    db_name     => $db_name,
    db_username => $db_username,
    db_password => $db_password,
    db_charset  => $db_charset,
  }

  $db_settings = {
    'module-director-db' => {
      'section_name' => 'db',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => {
        'resource'   => 'icingaweb2-module-director'
      }
    }
  }

  if $import_schema {
    ensure_packages(['icingacli'], { 'ensure' => 'present' })

    exec { 'director-migration':
      command => 'icingacli director migration run',
      onlyif  => 'icingacli director migration pending',
      require => [ Package['icingacli'], Icingaweb2::Module['director'] ]
    }

    if $kickstart {
      $kickstart_settings = {
        'module-director-config' => {
          'section_name' => 'config',
          'target'       => "${module_conf_dir}/kickstart.ini",
          'settings'     => {
            'endpoint'   => $endpoint,
            'host'       => $api_host,
            'port'       => $api_port,
            'username'   => $api_username,
            'password'   => $api_password,
          }
        }
      }

      exec { 'director-kickstart':
        command => 'icingacli director kickstart run',
        onlyif  => 'icingacli director kickstart required',
        require => Exec['director-migration']
      }
    } else {
      $kickstart_settings = {}
    }
  } else {
    $kickstart_settings = {}
  }

  icingaweb2::module {'director':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    settings       => merge($db_settings, $kickstart_settings),
  }
}
