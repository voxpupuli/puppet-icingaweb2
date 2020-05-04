# @summary
#   Installs and enables the cube module.
#
# @note If you want to use `git` as `install_method`, the CLI `git` command has to be installed. You can manage it yourself as package resource or declare the package name in icingaweb2 class parameter `extra_packages`.
#
# @param [Enum['absent', 'present']] ensure
#   Enable or disable module.
#
# @param [String] git_repository
#   Set a git repository URL.
#
# @param [Optional[String]] git_revision
#   Set either a branch or a tag name, eg. `master` or `v1.0.0`.
#
# @example
#   class { 'icingaweb2::module::cube':
#     git_revision => 'v1.0.0'
#   }
#
class icingaweb2::module::cube(
  String                      $git_repository,
  Enum['absent', 'present']   $ensure         = 'present',
  Optional[String]            $git_revision   = undef,
){
  icingaweb2::module {'cube':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }
}
