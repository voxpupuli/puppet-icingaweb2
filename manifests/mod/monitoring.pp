# == Class icingaweb2::mod::monitoring
#
class icingaweb2::mod::monitoring (
  $protected_customvars = '*pw*,*pass*,community',
  $backend_type         = 'ido',
  $backend_resource     = 'icinga_ido',
  $transport            = 'local',
  $transport_host       = undef,
  $transport_port       = undef,
  $transport_username   = undef,
  $transport_password   = undef,
  $transport_path       = '/var/run/icinga2/cmd/icinga2.cmd',
) {
  require ::icingaweb2

  validate_re($transport, '^(local|remote|api)$', 'Supported transports are local, remote or api')
  if $transport != 'api' {
    validate_absolute_path($transport_path)
  }
  if $transport != 'api' and $transport_password {
    fail('transport_password only works with transport => api')
  }

  if $transport_port {
    validate_numeric($transport_port)
    $_port = $transport_port
  } elsif $transport == 'api' {
    $_port = 5665
  } else {
    $_port = 22
  }

  File {
    require => Class['::icingaweb2::config'],
    owner => $::icingaweb2::config_user,
    group => $::icingaweb2::config_group,
    mode  => $::icingaweb2::config_file_mode,
  }

  $monitoring_mod_files = [
    "${::icingaweb2::config_dir}/modules/monitoring/backends.ini",
    "${::icingaweb2::config_dir}/modules/monitoring/config.ini",
    "${::icingaweb2::config_dir}/modules/monitoring/commandtransports.ini",
  ]

  file { $monitoring_mod_files:
    ensure => present,
  }

  file { "${::icingaweb2::config_dir}/modules/monitoring":
    ensure => directory,
    mode   => $::icingaweb2::config_dir_mode;
  }

  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/modules/monitoring"],
  }

  ini_setting { 'security settings':
    section => 'security',
    setting => 'protected_customvars',
    value   => "\"${protected_customvars}\"",
    path    => "${::icingaweb2::config_dir}/modules/monitoring/config.ini",
  }

  ini_setting { 'backend ido setting':
    section => 'icinga_ido',
    setting => 'type',
    value   => $backend_type,
    path    => "${::icingaweb2::config_dir}/modules/monitoring/backends.ini",
  }

  ini_setting { 'backend resource setting':
    section => 'icinga_ido',
    setting => 'resource',
    value   => $backend_resource,
    path    => "${::icingaweb2::config_dir}/modules/monitoring/backends.ini",
  }

  ini_setting { 'command transport setting':
    section => 'icinga2',
    setting => 'transport',
    value   => $transport,
    path    => "${::icingaweb2::config_dir}/modules/monitoring/commandtransports.ini",
  }

  if $transport == 'local' or $transport == 'remote' {
    $_path_ensure = present
  } else {
    $_path_ensure = absent
  }

  ini_setting { 'command transport path setting':
    ensure  => $_path_ensure,
    section => 'icinga2',
    setting => 'path',
    value   => $transport_path,
    path    => "${::icingaweb2::config_dir}/modules/monitoring/commandtransports.ini",
  }

  if $transport == 'remote' or $transport == 'api' {
    ini_setting { 'command transport host setting':
      section => 'icinga2',
      setting => 'host',
      value   => $transport_host,
      path    => "${::icingaweb2::config_dir}/modules/monitoring/commandtransports.ini",
    }

    ini_setting { 'command transport port setting':
      section => 'icinga2',
      setting => 'port',
      value   => $_port,
      path    => "${::icingaweb2::config_dir}/modules/monitoring/commandtransports.ini",
    }
  }

  $_user_ensure = $transport ? {
    'remote' => present,
    default  => absent,
  }

  ini_setting { 'command transport user setting':
    ensure  => $_user_ensure,
    section => 'icinga2',
    setting => 'user',
    value   => $transport_username,
    path    => "${::icingaweb2::config_dir}/modules/monitoring/commandtransports.ini",
  }

  $_username_ensure = $transport ? {
    'api'   => present,
    default => absent,
  }

  ini_setting { 'command transport username setting':
    ensure  => $_username_ensure,
    section => 'icinga2',
    setting => 'username',
    value   => $transport_username,
    path    => "${::icingaweb2::config_dir}/modules/monitoring/commandtransports.ini",
  }

  $_password_ensure = $transport ? {
    'api'   => present,
    default => absent,
  }

  ini_setting { 'command transport password setting':
    ensure  => $_password_ensure,
    section => 'icinga2',
    setting => 'password',
    value   => $transport_password,
    path    => "${::icingaweb2::config_dir}/modules/monitoring/commandtransports.ini",
  }

  file { "${::icingaweb2::config_dir}/enabledModules/monitoring":
    ensure => link,
    target => '/usr/share/icingaweb2/modules/monitoring'
  }
}
