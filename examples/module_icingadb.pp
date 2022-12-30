$password = Sensitive('super(secret')

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
  icingadb_host             => 'localhost',
  icingadb_db_name          => 'icingadb',
  icingadb_db_username      => 'icingadb',
  icingadb_db_password      => Sensitive('supersecret'),
  icingadb_redis_password   => Sensitive('supersecret'), 
  commandtransports    => {
    icinga2 => {
      transport => 'api',
      username  => 'root',
      password  => Sensitive('icinga'),
    }
  }
}
