# @summary
#   Installs and enables the businessprocess module.
#
# @param [Enum['absent', 'present']] ensure
#   Enable or disable module.
#
# @param [String] git_repository
#   Set a git repository URL.
#
# @param [Optional[String]] git_revision
#   Set either a branch or a tag name, eg. `master` or `v2.1.0`.
#
# @note Check out the [Business Process mdoule documentation](https://www.icinga.com/docs/businessprocess/latest/) for requirements.
#
# @example
#   class { 'icingaweb2::module::businessprocess':
#     git_revision => 'v2.1.0'
#   }
#
class icingaweb2::module::businessprocess(
  String                      $git_repository,
  Enum['absent', 'present']   $ensure         = 'present',
  Optional[String]            $git_revision   = undef,
){
  icingaweb2::module {'businessprocess':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }
}
