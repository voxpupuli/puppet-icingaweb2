# @summary
#   Download, enable and configure Icinga Web 2 modules.
#
# @note If you want to use `git` as `install_method`, the CLI `git` command has to be installed. You can manage it yourself as package resource or declare the package name in icingaweb2 class parameter `extra_packages`.
#
# @param ensure
#   Enable or disable module.
#
# @param module
#   Name of the module.
#
# @param module_dir
#   Target directory of the module. Defaults to first item of `module_path`.
#
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method. Defaults to `git`
#
# @param git_repository
#   The git repository. This setting is only valid in combination with the installation method `git`.
#
# @param git_revision
#   Tag or branch of the git repository. This setting is only valid in combination with the installation method `git`.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param settings
#   A hash with the module settings. Multiple configuration files with ini sections can be configured with this hash.
#   The `module_name` should be used as target directory for the configuration files.
#
# @example
#   $conf_dir        = $icingaweb2::globals::conf_dir
#   $module_conf_dir = "${conf_dir}/modules/mymodule"
#
#   $settings = {
#     'section1' => {
#       'target'   => "${module_conf_dir}/config1.ini",
#       'settings' => {
#         'setting1' => 'value1',
#         'setting2' => 'value2',
#       }
#     },
#     'section2' => {
#       'target'   => "${module_conf_dir}/config2.ini",
#       'settings' => {
#         'setting3' => 'value3',
#         'setting4' => 'value4',
#       }
#     }
#   }
#
define icingaweb2::module (
  Enum['absent', 'present']         $ensure         = 'present',
  String[1]                         $module         = $title,
  Stdlib::Absolutepath              $module_dir     = "${icingaweb2::globals::default_module_path}/${title}",
  Enum['git', 'none', 'package']    $install_method = 'git',
  Optional[String[1]]               $git_repository = undef,
  String                            $git_revision   = 'master',
  Optional[String[1]]               $package_name   = undef,
  Hash[String[1], Any]              $settings       = {},
) {
  require icingaweb2

  $conf_dir   = $icingaweb2::globals::conf_dir
  $state_dir  = $icingaweb2::globals::state_dir
  $conf_user  = $icingaweb2::conf_user
  $conf_group = $icingaweb2::conf_group

  $enable_module = if $ensure == 'present' {
    'link'
  } else {
    'absent'
  }

  case $install_method {
    'none': {}
    'git': {
      vcsrepo { $module_dir:
        ensure   => present,
        provider => 'git',
        source   => $git_repository,
        revision => $git_revision,
      }
    }
    'package': {
      unless $package_name {
        fail('You choose install method package but did not set a package_name.')
      }

      package { $package_name:
        ensure => installed,
      }
    }
    default: {
      fail('The installation method you provided is not supported.')
    }
  }

  file {
    default:
      owner => $conf_user,
      group => $conf_group,
    ;
    "${conf_dir}/enabledModules/${module}":
      ensure => $enable_module,
      target => $module_dir,
    ;
    ["${conf_dir}/modules/${module}", "${state_dir}/${module}"]:
      ensure => directory,
      owner  => 'root',
      mode   => '2770',
    ;
  }

  create_resources('icingaweb2::inisection', $settings)
}
