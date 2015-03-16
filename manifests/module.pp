# == Define: icingaweb2::module
#
define icingaweb2::module(
  $ensure = 'enabled',
) {

  validate_re($ensure, '^(en|dis)abled$', 'ensure must be one of: enabled or disabled')

  include ::icingaweb2

  File {
    owner => $::icingaweb2::config_user,
    group => $::icingaweb2::config_group,
  }

  if $ensure == 'disabled' {
    $symlink = absent
  }
  else {
    $symlink = link
  }

  file { "icingaweb2-module-${name}-symlink":
    ensure => $symlink,
    path   => "${icingaweb2::config_dir}/enabledModules/${name}",
    target => "${icingaweb2::web_root}/modules/${name}",
  }

  file { "icingaweb2-module-${name}-config":
    ensure => directory,
    path   => "${icingaweb2::config_dir}/modules/${name}",
    mode   => $::icingaweb2::config_dir_mode,
  }

}
