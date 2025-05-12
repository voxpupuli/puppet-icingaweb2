# @summary
#   Installs and enables the perfdatagraphs module.
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
# @param default_backend
#   Backend type.
#
# @param default_timerange
#   Default timerange to show. Has to be in format defined in ISO 8601, e.g. PT12H.
#
# @param cache_lifetime
#   Cache lifetime in seconds.
#
class icingaweb2::module::perfdatagraphs (
  Enum['absent', 'present']      $ensure,
  Stdlib::HTTPUrl                $git_repository,
  Enum['git', 'none', 'package'] $install_method,
  Enum['Graphite']               $default_backend,
  String[1]                      $default_timerange = 'PT12H',
  Optional[Integer[1]]           $cache_lifetime    = undef,
  Optional[String[1]]            $package_name      = undef,
  Stdlib::Absolutepath           $module_dir        = "${icingaweb2::globals::default_module_path}/perfdatagraphs",
  Optional[String[1]]            $git_revision      = undef,
) {
  require icingaweb2

  $conf_dir        = $icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/perfdatagraphs"
  $config_settings = {
    default_backend   => $default_backend,
    default_timerange => $default_timerange,
    cache_lifetime    => $cache_lifetime,
  }

  $settings = {
    'icingaweb2-module-perfdatagraphs' => {
      'section_name' => 'perfdatagraphs',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($config_settings),
    },
  }

  icingaweb2::module { 'perfdatagraphs':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
    settings       => $settings,
  }
}
