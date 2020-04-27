# @summary
#   The fileshipper module extends the Director. It offers import sources to deal with CSV, JSON, YAML and XML files.
#
# @param [Enum['absent', 'present']] ensure
#   Enables or disables module.
#
# @param [String] git_repository
#   Set a git repository URL.
#
# @param [Optional[String]] git_revision
#   Set either a branch or a tag name, eg. `master` or `v1.3.2`.
#
# @param [Hash] base_directories
#   Hash of base directories. These directories can later be selected in the import source (Director).
#
# @param [Hash] directories
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
class icingaweb2::module::fileshipper(
  String                      $git_repository,
  Enum['absent', 'present']   $ensure           = 'present',
  Optional[String]            $git_revision     = undef,
  Hash                        $base_directories = {},
  Hash                        $directories      = {},
){

  $conf_dir        = $::icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/fileshipper"

  if $base_directories {
    $base_directories.each |$identifier, $directory| {
      icingaweb2::module::fileshipper::basedir{$identifier:
        basedir => $directory,
      }
    }
  }

  if $directories {
    $directories.each |$identifier, $settings| {
      icingaweb2::module::fileshipper::directory{$identifier:
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
  }
}
