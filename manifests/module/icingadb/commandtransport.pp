# @summary
#   Manages commandtransport configuration for the icingadb module.
#
# @param commandtransport
#   The name of the commandtransport.
#
# @param host
#   Hostname/ip for the transport. Only needed for api transport.
#
# @param port
#   Port for the transport. Only needed for api transport.
#
# @param username
#   Username for the transport. Only needed for api transport.
#
# @param password
#   Password for the transport. Only needed for api transport.
#
# @api private
#
define icingaweb2::module::icingadb::commandtransport(
  String              $username,
  Icingaweb2::Secret  $password,
  String              $commandtransport = $title,
  Stdlib::Host        $host             = 'localhost',
  Stdlib::Port        $port             = 5665,
) {

  $conf_dir        = $::icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/icingadb"

  $settings = {
    transport => 'api',
    host      => $host,
    port      => $port,
    username  => $username,
    password  => icingaweb2::unwrap($password),
  }

  icingaweb2::inisection { "icingadb-commandtransport-${commandtransport}":
    section_name => $commandtransport,
    target       => "${module_conf_dir}/commandtransports.ini",
    settings     => $settings,
  }
}
