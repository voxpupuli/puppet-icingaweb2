# == Class: icingaweb2::module::generictts
#
# Install and enable the generictts module.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
# [*git_repository*]
#   Set a git repository URL. Defaults to github.
#
# [*git_revision*]
#   Set either a branch or a tag name, eg. `master` or `v2.0.0`.
#
# [*ticketsystems*]
#   A hash of ticketsystems. The hash expects a `patten` and a `url` for each ticketsystem. The regex pattern is to
#   match the ticket ID, eg. `/#([0-9]{4,6})/`. Place the ticket ID in the URL, eg.
#   `https://my.ticket.system/tickets/id=$1`
#
#   Example:
#   ticketsystems => {
#     system1 => {
#       pattern => '/#([0-9]{4,6})/',
#       url     => 'https://my.ticket.system/tickets/id=$1'
#     }
#   }
#
class icingaweb2::module::generictts(
  $ensure         = 'present',
  $git_repository = 'https://github.com/Icinga/icingaweb2-module-generictts.git',
  $git_revision   = undef,
  $ticketsystems  = undef,
){

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_string($git_repository)
  validate_string($git_revision)

  if $ticketsystems {
    validate_hash($ticketsystems)
    create_resources('icingaweb2::module::generictts::ticketsystem', $ticketsystems)
  }

  icingaweb2::module {'generictts':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }
}
