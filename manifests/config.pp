class icingaweb2::config {

  file { '/etc/php.d/timezone.ini':
    ensure  => file,
    content => "date.timezone = ${icingaweb2::timezone}",
  } ~> Service['httpd']

  # TODO: wont work without apache module
  $auth_mode = $icingaweb2::auth_mode
  case $auth_mode {
    'demo': {
      warning('auth_mode demo is not secure for production!')
    }
    default: {
      fail("auth_mode '${auth_mode}' is not known!")
    }
  }

  file { 'icingaweb2-apache2':
    ensure  => file,
    path    => "${::apache::confd_dir}/icingaweb2.conf",
    content => template('icingaweb2/icingaweb2.conf.erb'),
  } ~> Service['httpd']

  File {
    owner => 'root',
    group => 'icingaweb2',
    mode  => '0640',
  }

  file { '/etc/icingaweb2':
    ensure => directory,
    mode   => '2770',
  }

  file { '/etc/icingaweb2/enabledModules':
    ensure => directory,
    mode   => '2770',
  }

  file { '/etc/icingaweb2/modules':
    ensure => directory,
    mode   => '2770',
  }

  file { '/etc/icingaweb2/preferences':
    ensure => directory,
    mode   => '2770',
  }

  # TODO:

}
# vi: ts=2 sw=2 expandtab :
