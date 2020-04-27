# @summary
#   Installs and enables the incubator module.
#
# @param [Enum['absent', 'present']] ensure
#   Enable or disable module. Defaults to `present`
#
# @param [String] git_repository
#   Set a git repository URL. Defaults to github.
#
# @param [String] git_revision
#   Set either a branch or a tag name, eg. `stable/0.7.0` or `v0.7.0`.
#
class icingaweb2::module::incubator(
  String                      $git_repository,
  String                      $git_revision,
  Enum['absent', 'present']   $ensure         = 'present',
){

  icingaweb2::module { 'incubator':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }

}
