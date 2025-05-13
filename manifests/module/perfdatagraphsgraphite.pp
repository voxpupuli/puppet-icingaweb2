# @summary
#   Installs and enables the perfdatagraphsgraphite module.
#
# @note If you want to use `git` as `install_method`, the CLI `git` command has to be installed.
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
#   Set either a branch or a tag name, eg. `main` or `v0.1.1`.
#
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param api_url
#   URI to the graphite API.
#
# @param api_username
#   Username to authenticate to the graphite API.
#
# @param api_password
#   Password that belongs to `api_username`.
#
# @param api_timeout
#   Connection timeout to the graphite API.
#
# @param api_tls_insecure
#   Wether to validate the certificate of the graphite API.
#
# @param writer_host_name_template
#   Host template. See Icinga 2 feature `graphite`.
#
# @param writer_service_name_template
#   Service template. See Icinga 2 feature `graphite`.
#
class icingaweb2::module::perfdatagraphsgraphite (
  Enum['absent', 'present']      $ensure                       = 'present',
  Enum['git', 'none', 'package'] $install_method               = 'git',
  Optional[String[1]]            $package_name                 = undef,
  Stdlib::HTTPUrl                $git_repository               = 'https://github.com/NETWAYS/icingaweb2-module-perfdatagraphs-graphite.git',
  Optional[String[1]]            $git_revision                 = undef,
  Stdlib::Absolutepath           $module_dir                   = "${icingaweb2::globals::default_module_path}/perfdatagraphsgraphite",
  Stdlib::HTTPUrl                $api_url                      = 'http://127.0.0.1:8542',
  Optional[String[1]]            $api_username                 = undef,
  Optional[Icinga::Secret]       $api_password                 = undef,
  Optional[Integer[1]]           $api_timeout                  = undef,
  Boolean                        $api_tls_insecure             = false,
  Optional[String[1]]            $writer_host_name_template    = undef,
  Optional[String[1]]            $writer_service_name_template = undef,
) {
  require icingaweb2::module::perfdatagraphs

  $conf_dir        = $icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/perfdatagraphsgraphite"
  $config_settings = {
    api_url                      => $api_url,
    api_username                 => $api_username,
    api_password                 => $api_password,
    api_timeout                  => $api_timeout,
    api_tls_insecure             => $api_tls_insecure,
    writer_host_name_template    => $writer_host_name_template,
    writer_service_name_template => $writer_service_name_template,
  }

  $settings = {
    'icingaweb2-module-perfdatagraphsgraphite' => {
      'section_name' => 'graphite',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($config_settings),
    },
  }

  icingaweb2::module { 'perfdatagraphsgraphite':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
    settings       => $settings,
  }
}
