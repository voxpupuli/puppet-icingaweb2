$db_password = Sensitive('supersecret')

include postgresql::server

postgresql::server::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => postgresql::postgresql_password('icingaweb2', $db_password, false, $postgresql::server::password_encryption),
}

class { 'icingaweb2':
  manage_repos           => true,
  db_type                => 'pgsql',
  db_password            => $db_password,
  import_schema          => true,
  config_backend         => 'db',
  default_admin_username => 'icingaadmin',
  default_admin_password => 'icinga',
  require                => Postgresql::Server::Db['icingaweb2'],
}

postgresql::server::db { 'x509':
  user     => 'x509',
  password => postgresql::postgresql_password('reporting', $db_password, false, $postgresql::server::password_encryption),
}

class { 'icingaweb2::module::x509':
  ensure        => present,
  git_revision  => 'v1.2.1',
  db_type       => 'pgsql',
  db_password   => $db_password,
  db_charset    => 'UTF8',
  import_schema => true,
  require       => Postgresql::Server::Db['x509'],
}

include icingaweb2::module::x509::service
