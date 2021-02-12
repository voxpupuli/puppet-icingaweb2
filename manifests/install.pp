# @summary
#   Installs Icinga Web 2 and extra packages.
#
# @api private
#
class icingaweb2::install {

  assert_private("You're not supposed to use this defined type manually.")

  $package_name        = $::icingaweb2::globals::package_name
  $manage_package      = $::icingaweb2::manage_package
  $extra_packages      = $::icingaweb2::extra_packages

  if $manage_package {
    package { $package_name:
      ensure => installed,
    }
  }

  if $extra_packages {
    ensure_packages($extra_packages, { 'ensure' => installed })
  }
}
