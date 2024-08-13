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
#   Path of the chrome or Chrome/Chromium binary.
#
# @param force_temp_storage
#   Force using of local temp storage.
#
# @param remote_host
#   Connect a remote running Chrome/Chromium.
#
# @param remote_port
#   Port to connect the remote running Chrome/Chromium.
#
# @example
#   class { 'icingaweb2::module::pdfexport':
#     git_revision  => 'v0.10.0',
#     chrome_binary => '/usr/bin/chromium-browser',
#   }
#
class icingaweb2::module::pdfexport (
  Enum['absent', 'present']      $ensure,
  Stdlib::HTTPUrl                $git_repository,
  String[1]                      $package_name,
  Enum['git', 'none', 'package'] $install_method,
  Stdlib::Absolutepath           $module_dir         = "${icingaweb2::globals::default_module_path}/pdfexport",
  Optional[String[1]]            $git_revision       = undef,
  Optional[Stdlib::Absolutepath] $chrome_binary      = undef,
  Optional[Boolean]              $force_temp_storage = undef,
  Optional[Stdlib::Host]         $remote_host        = undef,
  Optional[Stdlib::Port]         $remote_port        = undef,
) {
  require icingaweb2

  $module_conf_dir = "${icingaweb2::globals::conf_dir}/modules/pdfexport"

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
        settings     => delete_undef_values({
            'binary'             => $chrome_binary,
            'force_temp_storage' => $force_temp_storage,
            'host'               => $remote_host,
            'port'               => $remote_port,
        }),
      },
    },
  }
}
