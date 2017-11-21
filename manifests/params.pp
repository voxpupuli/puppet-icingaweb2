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

  $package     = 'icingaweb2'

  case $::facts['os']['family'] {
    'redhat': {
      $conf_dir              = '/etc/icingaweb2'
      $conf_user             = 'apache'
      $conf_group            = 'icingaweb2'
      $module_path           = '/usr/share/icingaweb2/modules'
      $schema_dir            = '/usr/share/doc/icingaweb2/schema'
      $gettext_package_name  = 'gettext'
    } # RedHat

    'debian': {
      $conf_dir             = '/etc/icingaweb2'
      $conf_user            = 'www-data'
      $conf_group           = 'icingaweb2'
      $module_path          = '/usr/share/icingaweb2/modules'
      $schema_dir           = '/usr/share/icingaweb2/etc/schema'
      $gettext_package_name = 'gettext'
    } # Debian

    'suse': {
      $conf_dir             = '/etc/icingaweb2'
      $conf_user            = 'wwwrun'
      $conf_group           = 'icingaweb2'
      $module_path          = '/usr/share/icingaweb2/modules'
      $schema_dir           = '/usr/share/doc/icingaweb2/schema'
      $gettext_package_name = 'gettext-tools'
    } # Suse

    'FreeBSD': {
      $conf_dir             = '/usr/local/etc/icingaweb2'
      $conf_user            = 'www'
      $conf_group           = 'icingaweb2'
      $module_path          = '/usr/local/www/icingaweb2/modules'
      $schema_dir           = '/usr/local/www/icingaweb2/etc/schema'
      $gettext_package_name = 'gettext-runtime'
    } # FreeBSD

    default: {
      fail("Your plattform ${::facts['os']['family']} is not supported, yet.")
    }
  } # case $::osfamily
}

