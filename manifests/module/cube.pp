# @summary
#   Installs and enables the cube module.
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
#   Set either a branch or a tag name, eg. `master` or `v1.0.0`.
#
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @example
#   class { 'icingaweb2::module::cube':
#     git_revision => 'v1.0.0'
#   }
#
class icingaweb2::module::cube (
  Enum['absent', 'present']      $ensure         = 'present',
  Optional[Stdlib::Absolutepath] $module_dir     = undef,
  String                         $git_repository = 'https://github.com/Icinga/icingaweb2-module-cube.git',
  Optional[String]               $git_revision   = undef,
  Enum['git', 'none', 'package'] $install_method = 'git',
  String                         $package_name   = 'icingaweb2-module-cube',
) {
  icingaweb2::module { 'cube':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
  }
}
