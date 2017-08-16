# == Define: icingaweb2::module::monitoring
#
# Manage the monitoring module. This module is mandatory for probably every setup.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
# [*pretected_customvars*]
#   Custom variables in Icinga 2 may contain sensible information. Set patterns for custom variables that should be
#   hidden in the web interface. Defaults to `*pw*, *pass*, community`
#
# [*ido_type*]
#   Type of your IDO database. Either `mysql` or `pgsql`. Defaults to `mysql`
#
# [*ido_host*]
#   Hostname of the IDO database.
#
# [*ido_port*]
#   Port of the IDO database. Defaults to `3306`
#
# [*ido_db_name*]
#   Name of the IDO database.
#
# [*ido_db_username*]
#   Username for IDO DB connection.
#
# [*ido_db_password*]
#   Password for IDO DB connection.
#
# [*api_host*]
#   The API host is your Icinga 2.
#
# [*api_port*]
#   Port of your Icinga 2 API. Defaults to `5665`
#
# [*api_username*]
#   API username. This is needed to send commands to the Icinga 2 core Make sure you have a proper `ApiUser`
#   configuration object configured in Icinga 2.
#
# [*api_password*]
#   Password of the API user.
#
class icingaweb2::module::monitoring(
  $ensure               = 'present',
  $protected_customvars = '*pw*, *pass*, community',
  $ido_type             = 'mysql',
  $ido_host             = undef,
  $ido_port             = 3306,
  $ido_db_name          = undef,
  $ido_db_username      = undef,
  $ido_db_password      = undef,
  $api_host             = 'localhost',
  $api_port             = 5665,
  $api_username         = undef,
  $api_password         = undef,
){

  $conf_dir        = $::icingaweb2::params::conf_dir
  $module_conf_dir = "${conf_dir}/modules/monitoring"

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_string($protected_customvars)
  validate_re($ido_type, [ 'mysql', 'pgsql' ],
    "${ido_type} isn't supported. Valid values are 'mysql' and 'pgsql'.")
  validate_string($ido_host)
  validate_numeric($ido_port)
  validate_string($ido_db_name)
  validate_string($ido_db_username)
  validate_string($ido_db_password)
  validate_string($api_host)
  validate_numeric($api_port)
  validate_string($api_username)
  validate_string($api_password)

  icingaweb2::config::resource { 'icingaweb2-module-monitoring':
    type        => 'db',
    db_type     => $ido_type,
    host        => $ido_host,
    port        => $ido_port,
    db_name     => $ido_db_name,
    db_username => $ido_db_username,
    db_password => $ido_db_password,
  }

  $backend_settings = {
    'type'     => 'ido',
    'resource' => 'icingaweb2-module-monitoring',
  }

  $commandtransport_settings = {
    'transport' => 'api',
    'host'      => $api_host,
    'port'      => $api_port,
    'username'  => $api_username,
    'password'  => $api_password,
  }

  $config_settings = {
    'protected_customvars' => $protected_customvars
  }

  $settings = {
    'backends' => {
      'target'   => "${module_conf_dir}/backends.ini",
      'settings' => delete_undef_values($backend_settings)
    },
    'commandtransports' => {
      'target'   => "${module_conf_dir}/commandtransports.ini",
      'settings' => delete_undef_values($commandtransport_settings)
    },
    'config' => {
      'target'   => "${module_conf_dir}/config.ini",
      'settings' => delete_undef_values($config_settings)
    }
  }

  icingaweb2::module {'monitoring':
    ensure         => $ensure,
    install_method => 'none',
    module_dir     => '/usr/share/icingaweb2/modules/monitoring',
    settings       => $settings,
  }
}