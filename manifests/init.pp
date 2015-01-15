# == Class: icingaweb2
#
# Install icingaweb2 from RPM packages
#
# === Author
#
# Markus Frosch <markus.frosch@netways.de>
#
class icingaweb2 (
  $use_apache      = true,
  $timezone        = 'UTC',
  $auth_mode       = 'demo',
  $backend_type    = 'ido',
  $ido_db_host     = 'localhost',
  $ido_db_port     = undef,
  $ido_db_name     = 'icinga2',
  $ido_db_user     = 'icinga2',
  $ido_db_password = 'icinga2',
) {

  if $::osfamily != 'RedHat' {
    fail('This module is only designed for RedHat at the moment')
  }

  if $use_apache {
    include ::apache
    include ::apache::mod::php
    include ::apache::mod::rewrite
    Class['apache'] -> Class['icingaweb2::install']
  }

  class { 'icingaweb2::install': } ~>
  class { 'icingaweb2::config': } ~>
  class { 'icingaweb2::settings': } ~>
  class { 'icingaweb2::icinga2': } ~>

  # temporary fix for the apache module
  # TODO: check
  Service <| title == 'httpd' |> {
    hasrestart => true,
  }

}
# vi: ts=2 sw=2 expandtab :
