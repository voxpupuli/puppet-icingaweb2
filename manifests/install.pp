# == Class: icingaweb2::install
#
# This class handles the installation of the Icinga Web 2 package.
#
# === Parameters
#
# This class does not provide any parameters.
#
# === Examples
#
# This class is private and should not be called by others than this module.
#
class icingaweb2::install {

  if defined($caller_module_name) and $module_name != $caller_module_name {
    fail("icingaweb2::install is a private class of the module icingaweb2, you're not permitted to use it.")
  }

  $package        = $::icingaweb2::params::package
  $manage_package = $::icingaweb2::manage_package

  if $manage_package {
    package { $package:
      ensure => installed,
    }
  }
}