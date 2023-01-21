# @summary
#   Installs Icinga Web 2 and extra packages.
#
# @api private
#
class icingaweb2::install {
  assert_private("You're not supposed to use this defined type manually.")

  $conf_dir       = $icingaweb2::globals::conf_dir
  $package_name   = $icingaweb2::globals::package_name
  $manage_package = $icingaweb2::manage_package
  $extra_packages = $icingaweb2::extra_packages
  $conf_user      = $icingaweb2::conf_user
  $conf_group     = $icingaweb2::conf_group

  File {
    mode    => '0660',
    owner   => $conf_user,
    group   => $conf_group,
  }

  if $manage_package {
    package { $package_name:
      ensure => installed,
    }
  }

  if $extra_packages {
    ensure_packages($extra_packages, { 'ensure' => installed })
  }

  file { prefix(['navigation', 'preferences'], "${conf_dir}/"):
    ensure => directory,
    mode   => '2770',
  }
}
