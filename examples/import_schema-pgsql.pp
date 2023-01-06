include postgresql::server

postgresql::server::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => postgresql_password('icingaweb2', 'icingaweb2'),
}

class { 'icingaweb2':
  manage_repos  => true,
  import_schema => true,
  db_type       => 'pgsql',
  db_host       => 'localhost',
  db_username   => 'icingaweb2',
  db_password   => 'icingaweb2',
  require       => Postgresql::Server::Db['icingaweb2'],
}
