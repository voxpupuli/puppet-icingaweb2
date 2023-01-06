$password = Sensitive('super(secret')

include mysql::server

mysql::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => $password,
  host     => 'localhost',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER', 'REFERENCES'],
}

class { 'icingaweb2':
  manage_repos  => true,
  import_schema => true,
  db_type       => 'mysql',
  db_host       => 'localhost',
  db_port       => 3306,
  db_username   => 'icingaweb2',
  db_password   => $password,
  require       => Mysql::Db['icingaweb2'],
}

class { 'icingaweb2::module::monitoring':
  ido_host             => 'localhost',
  ido_db_name          => 'icinga2',
  ido_db_username      => 'icinga2',
  ido_db_password      => Sensitive('supersecret'),
  protected_customvars => ['*pw*', '*pass*', 'community', 'testabc'],
  commandtransports    => {
    icinga2 => {
      transport => 'api',
      username  => 'root',
      password  => Sensitive('icinga'),
    },
  },
}
