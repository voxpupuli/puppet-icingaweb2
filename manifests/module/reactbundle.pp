# @summary
#   Installs and enables the reactbundle module.
#
# @note If you want to use `git` as `install_method`, the CLI `git` command has to be installed. You can manage it yourself as package resource or declare the package name in icingaweb2 class parameter `extra_packages`.
#
# @param ensure
#   Enable or disable module.
#
# @param module_dir
#   Target directory of the module.
#
# @param git_repository
#   Set a git repository URL.
#
# @param git_revision
#   Set either a branch or a tag name, eg. `stable/0.7.0` or `v0.7.0`.
#
class icingaweb2::module::reactbundle (
  String                         $git_repository,
  String                         $git_revision,
  Enum['absent', 'present']      $ensure     = 'present',
  Optional[Stdlib::Absolutepath] $module_dir = undef,
) {
  icingaweb2::module { 'reactbundle':
    ensure         => $ensure,
    module_dir     => $module_dir,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }
}
