$db_password = Sensitive('supersecret')

class { 'icinga::repos':
  manage_extras => true,
}

include postgresql::server

postgresql::server::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => postgresql::postgresql_password('icingaweb2', $db_password, false, $postgresql::server::password_encryption),
}

class { 'icingaweb2':
  db_type                => 'pgsql',
  db_password            => $db_password,
  import_schema          => true,
  config_backend         => 'db',
  default_admin_username => 'icingaadmin',
  default_admin_password => 'icinga',
  require                => Postgresql::Server::Db['icingaweb2'],
}

postgresql::server::db { 'director':
  user     => 'director',
  password => postgresql::postgresql_password('director', $db_password, false, $postgresql::server::password_encryption),
}

class { 'icingaweb2::module::director':
  db_type        => 'pgsql',
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
  require        => Postgresql::Server::Db['director'],
}

include icingaweb2::module::director::service
