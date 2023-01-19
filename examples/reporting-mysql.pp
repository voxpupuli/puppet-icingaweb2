$db_password = Sensitive('supersecret')

case $facts['os']['family'] {
  'redhat': {
    $extra_packages = ['git', 'chromium']
    $chrome_bin     = '/usr/bin/chromium-browser'
  }
  'debian': {
    $extra_packages = ['git', 'chromium']
    $chrome_bin     = '/usr/bin/chromium'
  }
  default: {
    fail("Your plattform ${facts['os']['family']} is not supported by this example.")
  }
}

include mysql::server

mysql::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => $db_password,
  host     => 'localhost',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER', 'REFERENCES'],
}

class { 'icingaweb2':
  manage_repos           => true,
  extra_packages         => $extra_packages,
  db_type                => 'mysql',
  db_password            => $db_password,
  import_schema          => true,
  config_backend         => 'db',
  default_admin_username => 'icingaadmin',
  default_admin_password => 'icinga',
  require                => Mysql::Db['icingaweb2'],
}

class { 'icingaweb2::module::pdfexport':
  ensure        => present,
  git_revision  => 'v0.10.2',
  chrome_binary => $chrome_bin,
}

mysql::db { 'reporting':
  user     => 'reporting',
  password => $db_password,
  host     => 'localhost',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE'],
}

class { 'icingaweb2::module::reporting':
  ensure        => present,
  git_revision  => 'v0.10.0',
  db_type       => 'mysql',
  db_password   => $db_password,
  import_schema => true,
  mail          => 'reporting@icinga.com',
  require       => Mysql::Db['reporting'],
}

include icingaweb2::module::reporting::service
