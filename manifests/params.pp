# == Class: icingaweb2::params
#
# In this class all default parameters are stored. It is inherited by other classes in order to get access to those
# parameters.
#
# === Parameters
#
# This class does not provide any parameters.
#
# === Examples
#
# This class is private and should not be called by others than this module.
#
class icingaweb2::params {

  $package          = 'icingaweb2'
  $conf_dir         = '/etc/icingaweb2'
  $module_path      = '/usr/share/icingaweb2/modules'

  case $::osfamily {
    'redhat': {
      $conf_user  = 'apache'
      $conf_group = 'icingaweb2'
    } # RedHat

    'debian': {
      $conf_user  = 'www-data'
      $conf_group = 'icingaweb2'
    } # Debian

    'suse': {
      $conf_user  = 'wwwrun'
      $conf_group = 'icingaweb2'
    } # Suse

    default: {
      fail("Your plattform ${::osfamily} is not supported, yet.")
    }
  } # case $::osfamily
}

