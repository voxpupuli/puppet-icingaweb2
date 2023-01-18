# @summary
#   The fileshipper module extends the Director. It offers import sources to deal with CSV, JSON, YAML and XML files.
#
# @note If you want to use `git` as `install_method`, the CLI `git` command has to be installed. You can manage it yourself as package resource or declare the package name in icingaweb2 class parameter `extra_packages`.
#
# @param ensure
#   Enables or disables module.
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
#   Set either a branch or a tag name, eg. `master` or `v1.3.2`.
#
# @param base_directories
#   Hash of base directories. These directories can later be selected in the import source (Director).
#
# @param directories
#   Deploy plain Icinga 2 configuration files through the Director to your Icinga 2 master.
#
# @note To understand this modulei, please read [Fileshipper module documentation](https://www.icinga.com/docs/director/latest/fileshipper/doc/02-Installation/).
#
# @note You've to manage source and target directories yourself.
#
# @example:
#   class { 'icingaweb2::module::fileshipper':
#     git_revision => 'v1.0.1',
#     base_directories => {
#       temp => '/var/lib/fileshipper'
#     },
#     directories      => {
#       'test' => {
#         'source'     => '/var/lib/fileshipper/source',
#         'target'     => '/var/lib/fileshipper/target',
#       }
#     }
#   }
#
class icingaweb2::module::fileshipper (
  Enum['absent', 'present']      $ensure           = 'present',
  Optional[Stdlib::Absolutepath] $module_dir       = undef,
  String                         $git_repository   = 'https://github.com/Icinga/icingaweb2-module-fileshipper.git',
  Optional[String]               $git_revision     = undef,
  Enum['git', 'none', 'package'] $install_method   = 'git',
  String                         $package_name     = 'icingaweb2-module-fileshipper',
  Hash                           $base_directories = {},
  Hash                           $directories      = {},
) {
  icingaweb2::assert_module()

  $conf_dir        = $icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/fileshipper"

  if $base_directories {
    $base_directories.each |$identifier, $directory| {
      icingaweb2::module::fileshipper::basedir { $identifier:
        basedir => $directory,
      }
    }
  }

  if $directories {
    $directories.each |$identifier, $settings| {
      icingaweb2::module::fileshipper::directory { $identifier:
        source     => $settings['source'],
        target     => $settings['target'],
        extensions => $settings['extensions'],
      }
    }
  }

  icingaweb2::module { 'fileshipper':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
  }
}
