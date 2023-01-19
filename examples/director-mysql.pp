$db_password = Sensitive('supersecret')

class { 'icinga::repos':
  manage_extras => true,
}

include mysql::server

mysql::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => $db_password,
  host     => 'localhost',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER', 'REFERENCES'],
}

class { 'icingaweb2':
  db_type                => 'mysql',
  db_password            => $db_password,
  import_schema          => true,
  config_backend         => 'db',
  default_admin_username => 'icingaadmin',
  default_admin_password => 'icinga',
  require                => Mysql::Db['icingaweb2'],
}

mysql::db { 'director':
  user     => 'director',
  password => $db_password,
  host     => 'localhost',
  charset  => 'utf8',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER', 'REFERENCES'],
}

class { 'icingaweb2::module::director':
  db_type        => 'mysql',
  db_host        => 'localhost',
  db_name        => 'director',
  db_username    => 'director',
  db_password    => $db_password,
  import_schema  => true,
  kickstart      => false,
  endpoint       => 'monitoring.icinga.com',
  api_username   => 'director',
  api_password   => Sensitive('icinga'),
  install_method => 'package',
  require        => Mysql::Db['director'],
}

include icingaweb2::module::director::service
