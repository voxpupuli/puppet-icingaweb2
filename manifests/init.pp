# == Class: icingaweb2
#
# This module installs and configures Icinga Web 2.
#
# === Parameters
#
# [*logging*]
#   Whether Icinga Web 2 should log to 'file' or to 'syslog'. Setting 'none' disables logging. Defaults to 'file'.
#
# [*logging_file*]
#   If 'logging' is set to 'file', this is the target log file. Defaults to '/var/log/icingaweb2/icingaweb2.log'.
#
# [*logging_level*]
#   Logging verbosity. Possible values are 'ERROR', 'WARNING', 'INFO' and 'DEBUG'. Defaults to 'INFO'.
#
# [*enable_stacktraces*]
#   Whether to display stacktraces in the web interface or not. Defaults to 'false'.
#
# [*module_path*]
#   Path to module sources. Multiple paths must be separated by colon. Defaults to '/usr/share/icingaweb2/modules'.
#
# [*theme*]
#   The default theme setting. Users may override this settings. Defaults to 'icinga'.
#
# [*theme_access*]
#   Whether users can change themes or not. Defaults to 'true'.
#
# [*manage_repo*]
#   When set to true this module will install the packages.icinga.com repository. With this official repo you can get
#   the latest version of Icinga Web. When set to false the operating systems default will be used. Defaults to false.
#   NOTE: will be ignored if manage_package is set to false.
#
# [*manage_package*]
#   If set to false packages aren't managed. Defaults to true.
#
# === Examples
#
#
class icingaweb2 (
  Enum['file', 'syslog', 'none']            $logging          = 'file',
  Stdlib::Absolutepath                      $logging_file     = '/var/log/icingaweb2/icingaweb2.log',
  Enum['ERROR', 'WARNING', 'INFO', 'DEBUG'] $logging_level    = 'INFO',
  Boolean                                   $show_stacktraces = false,
  Stdlib::Absolutepath                      $module_path      = $::icingaweb2::params::module_path,
  String                                    $theme            = 'Icinga',
  Boolean                                   $theme_disabled   = false,
  Boolean                                   $manage_repo      = false,
  Boolean                                   $manage_package   = true,
  Boolean                                   $import_schema    = false,
  Enum['mysql', 'pgsql']                    $db_type          = 'mysql',
  String                                    $db_host          = 'localhost',
  Integer[1,65535]                          $db_port          = 3306,
  String                                    $db_name          = 'icingaweb2',
  Optional[String]                          $db_username      = undef,
  Optional[String]                          $db_password      = undef,
  Enum['ini', 'db']                         $config_backend   = 'ini',
) inherits ::icingaweb2::params {

  anchor { '::icingaweb2::begin': }
  -> class { '::icingaweb2::repo': }
  -> class { '::icingaweb2::install': }
  -> class { '::icingaweb2::config': }
  -> anchor { '::icingaweb2::end': }

}
