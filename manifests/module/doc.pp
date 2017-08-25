# == Class: icingaweb2::module::doc
#
# Install and configure the doc module.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
class icingaweb2::module::doc(
  $ensure        = 'present',
){

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")

  case $::osfamily {
    'Debian': {
      $install_method = 'package'
      $package_name   = 'icingaweb2-module-doc'
    }
    default: {
      $install_method = 'none'
      $package_name   = undef
    }
  }

  icingaweb2::module { 'doc':
    ensure         => $ensure,
    install_method => $install_method,
    package_name   => $package_name,
  }
}
