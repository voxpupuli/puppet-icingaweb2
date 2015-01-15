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

  # enable the monitoring module TODO
  file { '/etc/icingaweb2/enabledModules/monitoring':
    ensure => link,
    target => '/usr/share/icingaweb2/modules/monitoring',
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

}
# vi: ts=2 sw=2 expandtab :
