# @summary
#   Installs and enables the audit  module.
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
#   Set either a branch or a tag name, eg. `master` or `v1.0.2`.
#
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param log_type
#   Logging type to use.
#
# @param log_file
#   Location of the log file. Only valid if `log_type` is set to `file`.
#
# @param log_ident
#   Logging prefix ident. Only valid if `log_type` is set to `syslog`. 
#
# @param log_facility
#   Facility to log to. Only valid if `log_type` is set to `syslog`.
#
# @param stream_format
#   Set to `json` to stream in JSON format. Disabled by setting to `none`.
#
# @param stream_file
#   Path to the stream destination.
#
# @example
#   class { 'icingaweb2::module::audit':
#     git_revision => 'v1.0.2',
#     log_type     => 'syslog',
#     log_facility => 'authpriv',
#   }
#
class icingaweb2::module::audit (
  Enum['absent', 'present']      $ensure         = 'present',
  Enum['git', 'none', 'package'] $install_method = 'git',
  Optional[String[1]]            $package_name   = undef,
  Stdlib::HTTPUrl                $git_repository = 'https://github.com/Icinga/icingaweb2-module-audit.git',
  Optional[String[1]]            $git_revision   = undef,
  Enum['file', 'syslog', 'none'] $log_type       = 'none',
  Variant[
    Enum['auth', 'user', 'authpriv'],
    Pattern[/^local[0-7]$/]
  ]                              $log_facility   = 'auth',
  Enum['json', 'none']           $stream_format  = 'none',
  Optional[Stdlib::Absolutepath] $stream_file    = undef,
  Optional[Stdlib::Absolutepath] $log_file       = undef,
  Optional[String]               $log_ident      = undef,
  Stdlib::Absolutepath           $module_dir     = "${icingaweb2::globals::default_module_path}/audit",
) {
  require icingaweb2

  $conf_dir        = $icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/audit"

  case $log_type {
    'file': {
      $log_settings = {
        'type' => 'file',
        'path' => $log_file,
      }
    }
    'syslog': {
      $log_settings = {
        'type'     => 'syslog',
        'ident'    => $log_ident,
        'facility' => $log_facility,
      }
    }
    default: {
      $log_settings = { 'type' => 'none', }
    }
  }

  $settings = {
    'icingaweb2-module-audit-log' => {
      'section_name' => 'log',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($log_settings),
    },
    'icingaweb2-module-audit-stream' => {
      'section_name' => 'stream',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values({
          'format' => $stream_format,
          'path'   => $stream_file,
      }),
    },
  }

  icingaweb2::module { 'audit':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
    settings       => $settings,
  }
}
