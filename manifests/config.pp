# == Class: icingaweb2::config
#
#
#
# === Parameters
#
# === Variables
#
# === Examples
#
# This class is private and should not be called by others than this module.
#
class icingaweb2::config {

  $conf_dir       = $::icingaweb2::params::conf_dir
  $conf_dir_purge = $::icingaweb2::params::conf_dir_purge
  $conf_user      = $::icingaweb2::params::conf_user
  $conf_group     = $::icingaweb2::params::conf_group

  File {
    mode  => '0660',
    owner => $config_user,
    group => $config_group
  }

  file {
    "${conf_dir}/authentication.ini":
      ensure => file;

    "${conf_dir}/config.ini":
      ensure => file;

    "${conf_dir}/resources.ini":
      ensure => file;

    "${conf_dir}/roles.ini":
      ensure => file;

    "${conf_dir}/groups.ini":
      ensure => file,
  }

}
