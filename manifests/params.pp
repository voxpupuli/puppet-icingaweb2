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
  $conf_dir    = '/etc/icingaweb2'
  $module_path = '/usr/share/icingaweb2/modules'

  case $facts['os']['family'] {
    'redhat': {
      $conf_user             = 'apache'
      $conf_group            = 'icingaweb2'
      $schema_dir            = '/usr/share/doc/icingaweb2/schema'
      $gettext_package_name  = 'gettext'
      $dependent_packages    = ['php-mysql', 'php-pgsql', 'php-ldap', 'php-gd', 'php-intl', 'php-pecl-imagick']
    } # RedHat

    'debian': {
      $conf_user            = 'www-data'
      $conf_group           = 'icingaweb2'
      $schema_dir           = '/usr/share/icingaweb2/etc/schema'
      $gettext_package_name = 'gettext'

      if $facts['os']['name'] == 'Ubuntu' and $facts['os']['release']['major'] == '16.04' {
        $dependent_packages   = ['php-mysql', 'php-pgsql', 'php-ldap', 'php-gd', 'php-intl', 'php-imagick']
      } else {
        $dependent_packages   = ['php5-mysql', 'php5-pgsql', 'php5-ldap', 'php5-gd', 'php5-intl', 'php5-imagick']
      }
    } # Debian

    'suse': {
      $conf_user            = 'wwwrun'
      $conf_group           = 'icingaweb2'
      $schema_dir           = '/usr/share/doc/icingaweb2/schema'
      $gettext_package_name = 'gettext-tools'
      $dependent_packages   = ['php5-mysql', 'php5-pgsql', 'php5-ldap', 'php5-gd', 'php5-intl', 'php5-imagick']
    } # Suse

    default: {
      fail("Your plattform ${::osfamily} is not supported, yet.")
    }
  } # case $::osfamily
}

