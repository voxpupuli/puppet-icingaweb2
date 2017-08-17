# == Define: icingaweb2::module::director
#
# Install and configure the director module.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
# [*git_revision*]
#   The director module is installed by cloning the git repository. Set either a branch or a tag name, eg. `master` or
#   `v1.3.2`.
#
# [*db_type*]
#   Type of your database. Either `mysql` or `pgsql`. Defaults to `mysql`
#
# [*db_host*]
#   Hostname of the database.
#
# [*db_port*]
#   Port of the database. Defaults to `3306`
#
# [*db_name*]
#   Name of the database.
#
# [*db_username*]
#   Username for DB connection.
#
# [*db_password*]
#   Password for DB connection.
#
# [*import_schema*]
#   Import database schema. Defaults to `false`
#
# [*kickstart*]
#   Run kickstart command after database migration. This requires `import_schema` to be `true`. Defaults to `false`
#
# [*endpoint*]
#   Endpoint object name of Icinga 2 API. This setting is only valid if `kickstart` is `true`.
#
# [*api_host*]
#   Icinga 2 API hostname. This setting is only valid if `kickstart` is `true`. Defaults to `localhost`
#
# [*api_port*]
#   Icinga 2 API port. This setting is only valid if `kickstart` is `true`. Defaults to `5665`
#
# [*api_username*]
#   Icinga 2 API username. This setting is only valid if `kickstart` is `true`.
#
# [*api_password*]
#   Icinga 2 API password. This setting is only valid if `kickstart` is `true`.
#
class icingaweb2::module::director(
  $ensure        = 'present',
  $git_revision  = undef,
  $db_type       = 'mysql',
  $db_host       = undef,
  $db_port       = 3306,
  $db_name       = undef,
  $db_username   = undef,
  $db_password   = undef,
  $import_schema = false,
  $kickstart     = false,
  $endpoint      = undef,
  $api_host      = 'localhost',
  $api_port      = 5665,
  $api_username  = undef,
  $api_password  = undef,
){
  $conf_dir        = $::icingaweb2::params::conf_dir
  $module_conf_dir = "${conf_dir}/modules/director"

  Exec {
    user => 'root',
    path => $::path,
  }

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_string($git_revision)
  validate_re($db_type, [ 'mysql', 'pgsql' ],
    "${db_type} isn't supported. Valid values are 'mysql' and 'pgsql'.")
  validate_string($db_host)
  validate_numeric($db_port)
  validate_string($db_name)
  validate_string($db_username)
  validate_string($db_password)
  validate_bool($import_schema)
  validate_bool($kickstart)

  icingaweb2::config::resource { 'icingaweb2-module-director':
    type        => 'db',
    db_type     => $db_type,
    host        => $db_host,
    port        => $db_port,
    db_name     => $db_name,
    db_username => $db_username,
    db_password => $db_password,
    db_charset  => 'utf8',
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
    exec { 'director-migration':
      command => 'icingacli director migration run',
      onlyif  => 'icingacli director migration pending',
    }

    if $kickstart {
      validate_string($endpoint)
      validate_string($api_host)
      validate_numeric($api_port)
      validate_string($api_username)
      validate_string($api_password)

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
        require => [ Exec['director-migration'], Icingaweb2::Module['director'] ]
      }
    }
  }

  icingaweb2::module {'director':
    ensure         => $ensure,
    git_repository => 'https://github.com/Icinga/icingaweb2-module-director.git',
    git_revision   => $git_revision,
    module_dir     => '/usr/share/icingaweb2/modules/director',
    settings       => merge($db_settings, $kickstart_settings),
  }
}