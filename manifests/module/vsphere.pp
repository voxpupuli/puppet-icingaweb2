# == Class: icingaweb2::module::vsphere
#
# The vSphere module extends the Director. It provides import sources for virtual machines and physical hosts
# from vSphere.
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
#   Set either a branch or a tag name, eg. `master` or `v1.3.2`.
#
# [*install_method*]
#   Install methods are `git`, `package` and `none` is supported as installation method. Defaults to `git`
#
# [*package_name*]
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#   Defaults to `icingaweb2-module-vsphere`
#
#
class icingaweb2::module::vsphere(
  Enum['absent', 'present']      $ensure         = 'present',
  String                         $git_repository = 'https://github.com/Icinga/icingaweb2-module-vsphere.git',
  Optional[String]               $git_revision   = undef,
  Enum['git', 'none', 'package'] $install_method = 'git',
  Optional[String]               $package_name   = 'icingaweb2-module-vsphere',
){

  icingaweb2::module { 'vsphere':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    package_name   => $package_name,
  }
}
