# @summary
#   Installs and enables the reactbundle module.
#
# @param [Enum['absent', 'present']] ensure
#   Enable or disable module.
#
# @param [String] git_repository
#   Set a git repository URL.
#
# @param [String] git_revision
#   Set either a branch or a tag name, eg. `stable/0.7.0` or `v0.7.0`.
#
class icingaweb2::module::reactbundle(
  String                    $git_repository,
  String                    $git_revision,
  Enum['absent', 'present'] $ensure         = 'present',
){

  icingaweb2::module { 'reactbundle':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }

}

