# @summary
#   Installs, configures and enables the pdfexport module.
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
#   Set either a branch or a tag name, eg. `master` or `v2.1.0`.
#
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param chrome_binary
#   Path of the chrome or chromium binary.
#
# @example
#   class { 'icingaweb2::module::pdfexport':
#     git_revision  => 'v0.10.0',
#     chrome_binary => '/usr/bin/chromium-browser',
#   }
#
class icingaweb2::module::pdfexport (
  Enum['absent', 'present']      $ensure         = 'present',
  Optional[Stdlib::Absolutepath] $module_dir     = undef,
  String                         $git_repository = 'https://github.com/Icinga/icingaweb2-module-pdfexport.git',
  Optional[String]               $git_revision   = undef,
  Enum['git', 'none', 'package'] $install_method = 'git',
  String                         $package_name   = 'icingaweb2-module-pdfexport',
  Optional[Stdlib::Absolutepath] $chrome_binary  = undef,
) {
  $conf_dir        = $icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/pdfexport"

  icingaweb2::module { 'pdfexport':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
    settings       => {
      'module-pdfexport-chrome' => {
        section_name => 'chrome',
        target       => "${module_conf_dir}/config.ini",
        settings     => {
          'binary' => $chrome_binary,
        },
      },
    },
  }
}
