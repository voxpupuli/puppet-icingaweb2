# == Define: icingaweb2::module::monitoring::commandtransport
#
# Manage commandtransport configuration for the monitoring module
#
# === Parameters
#
# [*commandtransport*]
#   The name of the commandtransport.
#
# [*transport*]
#   The transport type you wish to use. Either `api` or `local`. Defaults to `api`
#
# [*host*]
#   Hostname/ip for the transport. Only needed for api transport. Defaults to `localhost`
#
# [*port*]
#   Port for the transport. Only needed for api transport. Defaults to `5665`
#
# [*username*]
#   Username for the transport. Only needed for api transport.
#
# [*password*]
#   Password for the transport. Only needed for api transport.
#
# [*path*]
#   Path for the transport. Only needed for local transport. Defaults to `/var/run/icinga2/cmd/icinga2.cmd`
#
define icingaweb2::module::monitoring::commandtransport(
  $commandtransport = $title,
  $transport        = 'api',
  $host             = 'localhost',
  $port             = '5665',
  $username         = undef,
  $password         = undef,
  $path             = '/var/run/icinga2/cmd/icinga2.cmd',
){
  assert_private("You're not supposed to use this defined type manually.")

  $conf_dir        = $::icingaweb2::params::conf_dir
  $module_conf_dir = "${conf_dir}/modules/monitoring"

  validate_string($commandtransport)
  validate_re($transport, ['api', 'local' ],
    "${transport} isn't supported. Valid values are 'api' or 'local'.")

  case $transport {
    'api': {
      validate_string($host)
      validate_numeric($port)
      validate_string($username)
      validate_string($password)

      $commandtransport_settings = {
        'transport' => $transport,
        'host'      => $host,
        'port'      => $port,
        'username'  => $username,
        'password'  => $password,
      }
    }
    'local': {
      validate_absolute_path($path)

      $commandtransport_settings = {
        'transport' => $transport,
        'path'      => $path,
      }
    }
    default: {
      fail('The transport type you provided is not supported')
    }
  }

  icingaweb2::inisection { "monitoring-commandtransport-${commandtransport}":
    section_name => $commandtransport,
    target       => "${module_conf_dir}/commandtransports.ini",
    settings     => delete_undef_values($commandtransport_settings),
  }
}
