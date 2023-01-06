$password = Sensitive('super(secret')

class { 'apache':
  mpm_module => 'prefork',
}

class { 'apache::mod::php': }

case $facts['os']['family'] {
  'redhat': {
    package { 'php-pgsql': }

    file { '/etc/httpd/conf.d/icingaweb2.conf':
      ensure  => file,
      source  => 'puppet:///modules/icingaweb2/examples/apache2/icingaweb2.conf',
      require => Class['apache'],
      notify  => Service['httpd'],
    }
  }
  'debian': {
    class { 'apache::mod::rewrite': }

    file { '/etc/apache2/conf.d/icingaweb2.conf':
      ensure  => file,
      source  => 'puppet:///modules/icingaweb2/examples/apache2/icingaweb2.conf',
      require => Class['apache'],
      notify  => Service['apache2'],
    }
  }
  default: {
    fail("Your plattform ${facts['os']['family']} is not supported by this example.")
  }
}

include postgresql::server

postgresql::server::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => postgresql::postgresql_password('icingaweb2', $password, false, $postgresql::server::password_encryption),
}

class { 'icingaweb2':
  manage_repos  => true,
  import_schema => true,
  db_type       => 'pgsql',
  db_host       => 'localhost',
  db_port       => 5432,
  db_username   => 'icingaweb2',
  db_password   => $password,
  require       => Postgresql::Server::Db['icingaweb2'],
}

class { 'icingaweb2::module::icingadb':
  db_type           => 'pgsql',
  db_password       => Sensitive('supersecret'),
  redis_password    => Sensitive('supersecret'),
  commandtransports => {
    icinga2 => {
      username => 'root',
      password => Sensitive('icinga'),
    },
  },
}
