# @summary
#   Configures Icinga Web 2.
#
# @api private
#
class icingaweb2::config {
  $conf_dir             = $icingaweb2::globals::conf_dir
  $default_module_path  = $icingaweb2::globals::default_module_path
  $conf_user            = $icingaweb2::conf_user
  $conf_group           = $icingaweb2::conf_group

  $logging              = $icingaweb2::logging
  $logging_file         = $icingaweb2::logging_file
  $logging_dir          = dirname($icingaweb2::logging_file)
  $logging_level        = $icingaweb2::logging_level
  $logging_facility     = $icingaweb2::logging_facility
  $logging_application  = $icingaweb2::logging_application
  $show_stacktraces     = $icingaweb2::show_stacktraces
  $module_path          = any2array($icingaweb2::module_path)

  $theme                = $icingaweb2::theme
  $theme_disabled       = $icingaweb2::theme_disabled

  $cookie_path          = $icingaweb2::cookie_path

  $resources            = $icingaweb2::resources
  $user_backends        = $icingaweb2::user_backends
  $group_backends       = $icingaweb2::group_backends

  $import_schema        = $icingaweb2::import_schema
  $mysql_db_schema      = $icingaweb2::globals::mysql_db_schema
  $pgsql_db_schema      = $icingaweb2::globals::pgsql_db_schema
  $db                   = {
    type => $icingaweb2::db_type,
    name => $icingaweb2::db_name,
    host => $icingaweb2::db_host,
    port => pick($icingaweb2::db_port, $icingaweb2::globals::port[$icingaweb2::db_type]),
    user => $icingaweb2::db_username,
    pass => $icingaweb2::db_password,
  }

  $default_domain       = $icingaweb2::default_domain
  $admin_role           = $icingaweb2::admin_role
  $admin_username       = $icingaweb2::default_admin_username
  $admin_password       = icingaweb2::unwrap($icingaweb2::default_admin_password)
  $config_backend       = $icingaweb2::config_backend
  $config_resource      = $icingaweb2::config_backend ? {
    'ini' => undef,
    'db'  => "${db['type']}-icingaweb2",
  }

  $use_tls              = $icingaweb2::use_tls
  $tls                  = icingaweb2::cert::files(
    'client',
    $conf_dir,
    $icingaweb2::tls_key_file,
    $icingaweb2::tls_cert_file,
    $icingaweb2::tls_cacert_file,
    $icingaweb2::tls_key,
    $icingaweb2::tls_cert,
    $icingaweb2::tls_cacert,
  ) + {
    capath   => $icingaweb2::tls_capath,
    noverify => $icingaweb2::tls_noverify,
    cipher   => $icingaweb2::tls_cipher,
  }

  File {
    mode    => '0660',
    owner   => $conf_user,
    group   => $conf_group,
  }

  Exec {
    path     => $facts['path'],
    provider => shell,
    user     => 'root',
    require  => Icingaweb2::Tls::Client['icingaweb2 tls client config'],
  }

  file { $logging_dir:
    ensure => directory,
    mode   => '0750',
  }

  file { $logging_file:
    ensure => file,
    mode   => '0640',
  }

  icingaweb2::inisection { 'config-logging':
    section_name => 'logging',
    target       => "${conf_dir}/config.ini",
    settings     => {
      'log'         => $logging,
      'file'        => $logging_file,
      'level'       => $logging_level,
      'facility'    => $logging_facility,
      'application' => $logging_application,
    },
  }

  $settings = {
    'show_stacktraces' => $show_stacktraces,
    'module_path'      => join(unique([$default_module_path] + $module_path), ':'),
    'config_backend'   => $config_backend,
    'config_resource'  => $config_resource,
  }

  icingaweb2::inisection { 'config-global':
    section_name => 'global',
    target       => "${conf_dir}/config.ini",
    settings     => delete_undef_values($settings),
  }

  if $default_domain {
    icingaweb2::inisection { 'config-authentication':
      section_name => 'authentication',
      target       => "${conf_dir}/config.ini",
      settings     => {
        'default_domain' => $default_domain,
      },
    }
  }

  icingaweb2::inisection { 'config-themes':
    section_name => 'themes',
    target       => "${conf_dir}/config.ini",
    settings     => {
      'default'  => $theme,
      'disabled' => $theme_disabled,
    },
  }

  if $cookie_path {
    icingaweb2::inisection { 'config-cookie':
      section_name => 'cookie',
      target       => "${conf_dir}/config.ini",
      settings     => {
        'path'     => $cookie_path,
      },
    }
  }

  file { "${conf_dir}/modules":
    ensure => directory,
    mode   => '2770',
  }

  file { "${conf_dir}/enabledModules":
    ensure => directory,
    mode   => '2770',
  }

  # Additional resources
  $resources.each |String $res, Hash $cfg| {
    case $cfg['type'] {
      'ldap': {
        icingaweb2::resource::ldap { $res:
          * => delete($cfg, 'type'),
        }
      }
      'mysql', 'pgsql', 'oracle', 'mssql', 'ibm', 'oci', 'sqlite': {
        icingaweb2::resource::database { $res:
          * => $cfg,
        }
      }
      default: {
        fail("icingaweb2::resources::${res} uses an unknown resource type")
      }
    }
  }

  # Additional user and group backends for access control
  $user_backends.each |String $backend, Hash $cfg| {
    icingaweb2::config::authmethod { $backend:
      * => $cfg,
    }
  }
  $group_backends.each |String $backend, Hash $cfg| {
    icingaweb2::config::groupbackend { $backend:
      * => $cfg,
    }
  }

  if $import_schema or $config_backend == 'db' {
    icingaweb2::tls::client { 'icingaweb2 tls client config':
      args => $tls,
    }

    -> icingaweb2::resource::database { "${db['type']}-icingaweb2":
      type         => $db['type'],
      host         => $db['host'],
      port         => $db['port'],
      database     => $db['name'],
      username     => $db['user'],
      password     => $db['pass'],
      use_tls      => $use_tls,
      tls_noverify => $tls['noverify'],
      tls_key      => $tls['key_file'],
      tls_cert     => $tls['cert_file'],
      tls_cacert   => $tls['cacert_file'],
      tls_capath   => $tls['capath'],
      tls_cipher   => $tls['cipher'],
    }

    icingaweb2::config::groupbackend { "${db['type']}-group":
      backend  => 'db',
      resource => "${db['type']}-icingaweb2",
    }

    icingaweb2::config::authmethod { "${db['type']}-auth":
      backend  => 'db',
      resource => "${db['type']}-icingaweb2",
    }
  }

  if $import_schema {
    # determine the real dbms, because there are some differnces between
    # the mysql and mariadb client
    $real_db_type = if $import_schema =~ Boolean {
      if $db['type'] == 'pgsql' { 'pgsql' } else { 'mariadb' }
    } else {
      $import_schema
    }
    $db_cli_options = icingaweb2::db::connect($db + { type => $real_db_type }, $tls, $use_tls)

    if $admin_role {
      icingaweb2::config::role { $admin_role['name']:
        users       => if $admin_role['users'] { join(union([$admin_username], $admin_role['users']), ',') } else { $admin_username },
        groups      => if $admin_role['groups'] { join($admin_role['groups']) } else { undef },
        permissions => '*',
      }
    }

    case $db['type'] {
      'mysql': {
        exec { 'import schema':
          command => "mysql ${db_cli_options} < '${mysql_db_schema}'",
          unless  => "mysql ${db_cli_options} -Ns -e 'SELECT 1 FROM icingaweb_user'",
          notify  => Exec['create default admin user'],
        }

        exec { 'create default admin user':
          command     => "echo \"INSERT INTO icingaweb_user (name, active, password_hash) VALUES (\\\"${admin_username}\\\", 1, \\\"`php -r 'echo password_hash(\"${admin_password}\", PASSWORD_DEFAULT);'`\\\")\" | mysql ${db_cli_options} -Ns",
          refreshonly => true,
        }
      }
      'pgsql': {
        $_db_password = icingaweb2::unwrap($db['pass'])
        exec { 'import schema':
          environment => ["PGPASSWORD=${_db_password}"],
          command     => "psql '${db_cli_options}' -w -f ${pgsql_db_schema}",
          unless      => "psql '${db_cli_options}' -w -c 'SELECT 1 FROM icingaweb_user'",
          notify      => Exec['create default admin user'],
        }

        exec { 'create default admin user':
          environment => ["PGPASSWORD=${_db_password}"],
          command     => "echo \"INSERT INTO icingaweb_user (name, active, password_hash) VALUES ('${admin_username}', 1, '`php -r 'echo password_hash(\"${admin_password}\", PASSWORD_DEFAULT);'`')\" | psql '${db_cli_options}'",
          refreshonly => true,
        }
      }
      default: {
        fail('The database type you provided is not supported.')
      }
    }
  }
}
