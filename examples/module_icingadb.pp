$password = Sensitive('super(secret')

class { 'apache':
  mpm_module => 'prefork'
}

class { 'apache::mod::php': }

case $::osfamily {
  'redhat': {
    package { 'php-mysqlnd': }

    file {'/etc/httpd/conf.d/icingaweb2.conf':
      source  => 'puppet:///modules/icingaweb2/examples/apache2/icingaweb2.conf',
      require => Class['apache'],
      notify  => Service['httpd'],
    }
  }
  'debian': {
    class { 'apache::mod::rewrite': }

    file {'/etc/apache2/conf.d/icingaweb2.conf':
      source  => 'puppet:///modules/icingaweb2/examples/apache2/icingaweb2.conf',
      require => Class['apache'],
      notify  => Service['apache2'],
    }
  }
  default: {
    fail("Your plattform ${::osfamily} is not supported by this example.")
  }
}

include ::mysql::server

mysql::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => $password,
  host     => 'localhost',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER', 'REFERENCES'],
}


class {'icingaweb2':
  manage_repos  => true,
  import_schema => true,
  db_type       => 'mysql',
  db_host       => 'localhost',
  db_port       => 3306,
  db_username   => 'icingaweb2',
  db_password   => $password,
  require       => Mysql::Db['icingaweb2'],
}

class {'icingaweb2::module::icingadb':
  db_password       => Sensitive('supersecret'),
  redis_password    => Sensitive('supersecret'), 
  commandtransports => {
    icinga2 => {
      username => 'root',
      password => Sensitive('icinga'),
    }
  }
}
