# @summary
#   The vSphere module extends the Director. It provides import sources for virtual machines and physical hosts from vSphere.
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
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param git_revision
#   Set either a branch or a tag name, eg. `stable/0.7.0` or `v0.7.0`.
#
# @note Check out the [vSphere module documentation](https://www.icinga.com/docs/director/latest/vsphere/doc/).
#
class icingaweb2::module::vsphere (
  Enum['absent', 'present']      $ensure         = 'present',
  Optional[Stdlib::Absolutepath] $module_dir     = undef,
  String                         $git_repository = 'https://github.com/Icinga/icingaweb2-module-vsphere.git',
  Optional[String]               $git_revision   = undef,
  Enum['git', 'none', 'package'] $install_method = 'git',
  String                         $package_name   = 'icingaweb2-module-vsphere',
) {
  icingaweb2::assert_module()

  deprecation('icingaweb2::module::vsphere', 'icingaweb2::module::vsphere is deprecated and was replaced by icingaweb2::module::vspheredb.')

  icingaweb2::module { 'vsphere':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
  }
}
