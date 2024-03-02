$db_password = Sensitive('supersecret')

case $facts['os']['family'] {
  'redhat': {
    $extra_packages = ['git']
  }
  'debian': {
    $extra_packages = ['git']
  }
  default: {
    fail("Your plattform ${facts['os']['family']} is not supported by this example.")
  }
}

include postgresql::server

postgresql::server::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => postgresql::postgresql_password('icingaweb2', $db_password, false, $postgresql::server::password_encryption),
}

class { 'icingaweb2':
  manage_repos           => true,
  extra_packages         => $extra_packages,
  db_type                => 'pgsql',
  db_password            => $db_password,
  import_schema          => true,
  default_admin_username => 'icingaadmin',
  default_admin_password => 'icinga',
  require                => Postgresql::Server::Db['icingaweb2'],
}

class { 'icingaweb2::module::monitoring':
  ido_type             => 'pgsql',
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
