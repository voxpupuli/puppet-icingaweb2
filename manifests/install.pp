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

  assert_private("You're not supposed to use this defined type manually.")

  $package             = $::icingaweb2::params::package
  $manage_package      = $::icingaweb2::manage_package
  $dependent_packages  = $::icingaweb2::params::dependent_packages
  $manage_dependencies = $::icingaweb2::manage_dependencies

  if $manage_package {
    package { $package:
      ensure => installed,
    }
  }

  if $manage_dependencies {
    ensure_packages($dependent_packages, { 'ensure' => 'present' })
  }
}
