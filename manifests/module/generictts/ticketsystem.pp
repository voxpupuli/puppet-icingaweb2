# @summary
#   Manages ticketsystem configuration for the generictts module.
#
# @param ticketsystem
#   The name of the ticketsystem.
#
# @param pattern
#   A regex pattern to match ticket numbers, eg. `/#([0-9]{4,6})/`
#
# @param url
#   The URL to your ticketsystem. Place the ticket ID in the URL, eg. `https://my.ticket.system/tickets/id=$1`
#
# @api private
#
define icingaweb2::module::generictts::ticketsystem (
  String[1]                 $ticketsystem = $title,
  Optional[String[1]]       $pattern      = undef,
  Optional[Stdlib::HTTPUrl] $url          = undef,
) {
  assert_private("You're not supposed to use this defined type manually.")

  $module_conf_dir = $icingaweb2::module::generictts::module_conf_dir

  icingaweb2::inisection { "generictts-ticketsystem-${ticketsystem}":
    section_name => $ticketsystem,
    target       => "${module_conf_dir}/config.ini",
    settings     => {
      'pattern' => $pattern,
      'url'     => $url,
    },
  }
}
