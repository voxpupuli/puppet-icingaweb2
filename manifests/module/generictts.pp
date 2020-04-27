# @summary
#   Installs and enables the generictts module.
#
# @param [Enum['absent', 'present']] ensure
#   Enable or disable module.
#
# @param [String] git_repository
#   Set a git repository URL.
#
# @param [Optional[String]] git_revision
#   Set either a branch or a tag name, eg. `master` or `v2.0.0`.
#
# @param [Hash] ticketsystems
#   A hash of ticketsystems. The hash expects a `patten` and a `url` for each ticketsystem.
#   The regex pattern is to match the ticket ID, eg. `/#([0-9]{4,6})/`. Place the ticket ID
#   in the URL, eg. `https://my.ticket.system/tickets/id=$1`.
#
# @example
#   class { 'icingaweb2::module::generictts':
#     git_revision  => 'v2.0.0',
#     ticketsystems => {
#       'my-ticket-system' => {
#         pattern => '/#([0-9]{4,6})/',
#         url     => 'https://my.ticket.system/tickets/id=$1',
#       },
#     },
#   }
#
class icingaweb2::module::generictts(
  String                    $git_repository,
  Enum['absent', 'present'] $ensure         = 'present',
  Optional[String]          $git_revision   = undef,
  Hash                      $ticketsystems  = {},
){
  create_resources('icingaweb2::module::generictts::ticketsystem', $ticketsystems)

  icingaweb2::module {'generictts':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }
}
