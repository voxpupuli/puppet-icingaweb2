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
  default_admin_username => 'icingaadmin',
  default_admin_password => 'icinga',
  require                => Mysql::Db['icingaweb2'],
}

class { 'icingaweb2::module::icingadb':
  db_type           => 'mysql',
  db_password       => Sensitive('icingadb'),
  redis_password    => Sensitive('redis'),
  commandtransports => {
    icinga2 => {
      username => 'icinga',
      password => Sensitive('icinga'),
    },
  },
}
