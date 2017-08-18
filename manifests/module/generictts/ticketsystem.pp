# == Define: icingaweb2::module::generictts::ticketsystem
#
# Manage ticketsystem configuration for the generictts module.
#
# === Parameters
#
# [*ticketsystem*]
#   The name of the ticketsystem.
#
# [*pattern*]
#   A regex pattern to match ticket numbers, eg. `/#([0-9]{4,6})/`
#
# [*url*]
#   The URL to your ticketsystem. Place the ticket ID in the URL, eg. `https://my.ticket.system/tickets/id=$1`
#
define icingaweb2::module::generictts::ticketsystem(
  $ticketsystem = $title,
  $pattern      = undef,
  $url          = undef,
){
  assert_private("You're not supposed to use this defined type manually.")

  $conf_dir        = $::icingaweb2::params::conf_dir
  $module_conf_dir = "${conf_dir}/modules/generictts"

  validate_string($ticketsystem)
  validate_string($pattern)
  validate_string($url)

  icingaweb2::inisection { "generictts-ticketsystem-${ticketsystem}":
    section_name => $ticketsystem,
    target       => "${module_conf_dir}/config.ini",
    settings     => {
      'pattern'  => $pattern,
      'url'      => $url,
    }
  }
}