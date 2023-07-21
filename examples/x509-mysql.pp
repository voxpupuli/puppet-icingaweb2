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

mysql::db { 'x509':
  user     => 'x509',
  password => $db_password,
  host     => 'localhost',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE'],
}

class { 'icingaweb2::module::x509':
  ensure        => present,
  git_revision  => 'v1.2.1',
  db_type       => 'mysql',
  db_password   => $db_password,
  import_schema => true,
  require       => Mysql::Db['x509'],
}

include icingaweb2::module::x509::service
