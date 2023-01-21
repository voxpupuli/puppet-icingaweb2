$db_password = Sensitive('supersecret')

include mysql::server

mysql::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => $db_password,
  host     => 'localhost',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER', 'REFERENCES'],
}

class { 'icingaweb2':
  manage_repos           => true,
  db_type                => 'mysql',
  db_password            => $db_password,
  import_schema          => true,
  config_backend         => 'db',
  default_admin_username => 'icingaadmin',
  default_admin_password => 'icinga',
  require                => Mysql::Db['icingaweb2'],
}

class { 'icingaweb2::module::monitoring':
  ido_type             => 'mysql',
  ido_host             => 'localhost',
  ido_db_name          => 'icinga2',
  ido_db_username      => 'icinga2',
  ido_db_password      => Sensitive('icinga2'),
  protected_customvars => ['*pw*', '*pass*', '*community'],
  commandtransports    => {
    icinga2 => {
      transport => 'api',
      username  => 'icinga',
      password  => Sensitive('icinga'),
    },
  },
}

icingaweb2::config::navigation { 'TEST':
  owner  => 'icingaadmin',
  shared => true,
  users  => ['icingaadmin', 'lbetz'],
  groups => ['icingaadmins'],
  url    => 'monitoring/list/hosts',
}

icingaweb2::config::navigation { 'TEST 2':
  owner  => 'icingaadmin',
  shared => true,
  parent => 'TEST',
  url    => 'monitoring/list/hosts',
}

icingaweb2::config::navigation { 'TEST 3':
  owner  => 'icingaadmin',
  url    => 'monitoring/list/hosts',
  target => '_blank',
}

icingaweb2::config::navigation { 'TEST 4':
  owner  => 'icingaadmin',
  url    => 'monitoring/list/hosts?host_problem=1&sort=host_severity',
  target => '_blank',
  parent => 'TEST 3',
}

icingaweb2::config::navigation { 'TEST 5':
  owner  => 'icingaadmin',
  type   => 'host-action',
  url    => 'monitoring/list/hosts?host_problem=1&sort=host_severity',
  filter => '_host_name=test*',
}

icingaweb2::config::navigation { 'TEST 6':
  owner  => 'icingaadmin',
  type   => 'host-action',
  shared => true,
  url    => 'monitoring/list/hosts?host_problem=1&sort=host_severity',
  filter => '_host_name=test',
}
