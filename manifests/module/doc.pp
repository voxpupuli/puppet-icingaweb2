# @summary
#   The doc module provides an interface to the Icinga 2 and Icinga Web 2 documentation.
#
# @param ensure
#   Enable or disable module. Specific states can also be defined, depending on the operating system.
#
class icingaweb2::module::doc (
  String                         $ensure,
) {
  icingaweb2::assert_module()

  case $facts['os']['family'] {
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
