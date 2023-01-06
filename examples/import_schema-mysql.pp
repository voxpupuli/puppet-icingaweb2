include mysql::server

mysql::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => 'icingaweb2',
  host     => 'localhost',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER', 'REFERENCES'],
}

class { 'icingaweb2':
  manage_repos  => true,
  import_schema => true,
  db_type       => 'mysql',
  db_host       => 'localhost',
  db_username   => 'icingaweb2',
  db_password   => 'icingaweb2',
  require       => Mysql::Db['icingaweb2'],
}
