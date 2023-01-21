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
