include icinga::repos

class { 'apache':
  mpm_module => 'prefork',
}

include 'apache::mod::php'

case $facts['os']['family'] {
  'redhat': {
    $apache_extra_packages    = ['icingaweb2', 'php-pgsql', 'php-process']
    $apache_icingaweb2_config = '/etc/httpd/conf.d/icingaweb2.conf'
  }
  'debian': {
    $apache_extra_packages    = ['icingaweb2', 'php-pgsql']
    $apache_icingaweb2_config = '/etc/apache2/conf.d/icingaweb2.conf'

    include apache::mod::rewrite
  }
  default: {
    fail("Your plattform ${facts['os']['family']} is not supported by this example.")
  }
}

package { $apache_extra_packages:
  ensure => installed,
  notify => Service[$apache::service_name],
}

file { $apache_icingaweb2_config:
  ensure  => file,
  source  => 'puppet:///modules/icingaweb2/examples/apache2/icingaweb2.conf',
  require => Class['apache'],
  notify  => Service[$apache::service_name],
}
