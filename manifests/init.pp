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
  $logging            = 'file',
  $logging_file       = '/var/log/icingaweb2/icingaweb2.log',
  $logging_level      = 'INFO',
  $enable_stacktraces = false,
  $module_path        = $::icingaweb2::params::module_path,
  $theme              = 'Icinga',
  $theme_access       = true,
  $manage_repo        = false,
  $manage_package     = true,
  $import_schema      = false,
  $db_type            = 'mysql',
  $db_host            = 'localhost',
  $db_port            = '3306',
  $db_name            = 'icingaweb2',
  $db_username        = undef,
  $db_password        = undef,
) inherits ::icingaweb2::params {

  validate_re($logging, [ 'file', 'syslog', 'none' ],
    "${logging} isn't supported. Valid values are 'file', 'syslog' and 'none'.")
  validate_absolute_path($logging_file)
  validate_re($logging_level, [ 'ERROR', 'WARNING', 'INFO', 'DEBUG' ],
    "${logging_level} isn't supported. Valid values are 'ERROR', 'WARNING', 'INFO' and 'DEBUG'.")
  validate_bool($enable_stacktraces)
  validate_absolute_path($module_path)
  validate_string($theme)
  validate_bool($theme_access)
  validate_bool($manage_repo)
  validate_bool($manage_package)
  validate_bool($import_schema)

  if $import_schema {
    validate_re($db_type, [ 'mysql', 'pgsql' ],
      "${db_type} isn't supported. Valid values are 'mysql' and 'pgsql'.")
    validate_string($db_name)
    validate_string($db_username)
    validate_string($db_password)
  }

  $show_stacktraces = $enable_stacktraces ? {
    true    => '1',
    default => '0',
  }

  $theme_disabled = $theme_access ? {
    true    => '1',
    default => '0'
  }

  class { '::icingaweb2::repo': }
  -> class { '::icingaweb2::install': }
  -> class { '::icingaweb2::config': }

}
