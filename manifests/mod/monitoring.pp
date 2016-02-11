# == Class icingaweb2::mod::monitoring
#
class icingaweb2::mod::monitoring (
) {
  require ::icingaweb2

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
    value   => '"*pw*,*pass*,community"',
    path    => "${::icingaweb2::config_dir}/modules/monitoring/config.ini",
  }

  ini_setting { 'backend ido setting':
    section => 'icinga_ido',
    setting => 'type',
    value   => 'ido',
    path    => "${::icingaweb2::config_dir}/modules/monitoring/backends.ini",
  }

  ini_setting { 'backend resource setting':
    section => 'icinga_ido',
    setting => 'resource',
    value   => 'icinga_ido',
    path    => "${::icingaweb2::config_dir}/modules/monitoring/backends.ini",
  }

  ini_setting { 'command transport setting':
    section => 'icinga2',
    setting => 'transport',
    value   => 'local',
    path    => "${::icingaweb2::config_dir}/modules/monitoring/commandtransports.ini",
  }

  ini_setting { 'command transport path setting':
    section => 'icinga2',
    setting => 'path',
    value   => '/var/run/icinga2/cmd/icinga2.cmd',
    path    => "${::icingaweb2::config_dir}/modules/monitoring/commandtransports.ini",
  }

  file { "${::icingaweb2::config_dir}/enabledModules/monitoring":
    ensure => link,
    target => '/usr/share/icingaweb2/modules/monitoring'
  }

}
