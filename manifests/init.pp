# == Class: icingaweb2
#
# This module installs and configures Icinga Web 2.
#
# === Parameters
#
# [*manage_repo*]
#   When set to true this module will install the packages.icinga.com repository. With this official repo you can get
#   the latest version of Icinga Web. When set to false the operating systems default will be used. Defaults to false.
#   NOTE: will be ignored if manage_package is set to false.
#
# [*manage_package*]
#   If set to false packages aren't managed. Defaults to true.
#
# === Variables
#
# === Examples
#
#

#This module installs and configures Icinga Web 2.
class icingaweb2 (
  $manage_repo    = false,
  $manage_package = true,
) inherits ::icingaweb2::params {

  validate_bool($manage_repo)
  validate_bool($manage_package)

  class { '::icingaweb2::repo': }
  -> class { '::icingaweb2::install': }
  -> class { '::icingaweb2::config': }

}
