# == Class: icingaweb2::settings
#
class icingaweb2::settings {

  # TODO: these files are temporary
  # they will be replaced by an ini handling...

  File {
    ensure  => file,
    owner   => 'root',
    group   => 'icingaweb2',
    mode    => '0660',
    #replace => false, # TODO: should only be temp
  }

  file { '/etc/icingaweb2/config.ini':
    content => template('icingaweb2/config.ini.erb'),
  }

  file { '/etc/icingaweb2/authentication.ini':
    content => template('icingaweb2/authentication.ini.erb'),
  }

  file { '/etc/icingaweb2/permissions.ini':
    content => template('icingaweb2/permissions.ini.erb'),
  }

  file { '/etc/icingaweb2/resources.ini':
    content => template('icingaweb2/resources.ini.erb'),
  }

  # enable the monitoring module TODO
  file { '/etc/icingaweb2/enabledModules/monitoring':
    ensure => link,
    target => '/usr/share/icingaweb2/modules/monitoring',
  }

  # create config dir for the module
  file { '/etc/icingaweb2/modules/monitoring':
    ensure => directory,
    mode   => '2770',
  }

  file { '/etc/icingaweb2/modules/monitoring/instances.ini':
    content => template('icingaweb2/instances.ini.erb'),
  }

  file { '/etc/icingaweb2/modules/monitoring/backends.ini':
    content => template('icingaweb2/backends.ini.erb'),
  }

}
# vi: ts=2 sw=2 expandtab :
