# == Class icingaweb2::config
#
class icingaweb2::config (
  $config_dir       = $::icingaweb2::config_dir,
  $config_dir_purge = $::icingaweb2::config_dir_purge,
  $web_root         = $::icingaweb2::web_root,
) {
  @user { 'icingaweb2':
    ensure     => present,
    home       => $::icingaweb2::web_root,
    managehome => true,
  }

  @group { 'icingaweb2':
    ensure => present,
    system => true,
  }

  realize(User['icingaweb2'])
  realize(Group['icingaweb2'])

  File {
    require => Class['::icingaweb2::install'],
    owner => $::icingaweb2::config_user,
    group => $::icingaweb2::config_group,
    mode  => $::icingaweb2::config_file_mode,
  }

  file {
    $::icingaweb2::config_dir:
      ensure  => directory,
      mode    => $::icingaweb2::config_dir_mode,
      purge   => $::icingaweb2::config_dir_purge,
      recurse => $::icingaweb2::config_dir_recurse;

    "${::icingaweb2::config_dir}/enabledModules":
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;

    "${::icingaweb2::config_dir}/modules":
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;

    "${::icingaweb2::config_dir}/authentication.ini":
      ensure => file;

    "${::icingaweb2::config_dir}/config.ini":
      ensure => file;

    "${::icingaweb2::config_dir}/resources.ini":
      ensure => file;

    "${::icingaweb2::config_dir}/roles.ini":
      ensure => file;

    $::icingaweb2::web_root:
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;

    "${::icingaweb2::web_root}/modules":
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;
  }

  # Configure authentication.ini settings
  case $::icingaweb2::auth_backend {
    'db': {
      icingaweb2::config::authentication_database { 'Local Database Authentication':
        auth_section  => 'icingaweb2',
        auth_resource => $::icingaweb2::auth_resource,
      }
    }
    'external': {
      icingaweb2::config::authentication_external { 'External Authentication':
        auth_section  => 'icingaweb2',
      }
    }
    default: {}
  }

  # Configure config.ini settings
  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/config.ini"],
    path    => "${::icingaweb2::config_dir}/config.ini",
  }

  # Logging Configuration
  ini_setting { 'icingaweb2 config logging method':
    section => 'logging',
    setting => 'log',
    value   => "\"${::icingaweb2::log_method}\"",
  }

  ini_setting { 'icingaweb2 config logging level':
    section => 'logging',
    setting => 'level',
    value   => "\"${::icingaweb2::log_level}\"",
  }

  ini_setting { 'icingaweb2 config logging application':
    section => 'logging',
    setting => 'application',
    value   => "\"${::icingaweb2::log_application}\"",
  }

  # Preferences Configuration
  ini_setting { 'icingaweb2 config preferences store':
    section => 'preferences',
    setting => 'store',
    value   => "\"${::icingaweb2::log_store}\"",
  }

  ini_setting { 'icingaweb2 config preferences resource':
    section => 'preferences',
    setting => 'resource',
    value   => "\"${::icingaweb2::log_resource}\"",
  }

  # Configure resources.ini
  icingaweb2::config::resource_database { 'icingaweb_db':
    resource_db       => $::icingaweb2::web_db,
    resource_host     => $::icingaweb2::web_db_host,
    resource_port     => $::icingaweb2::web_db_port,
    resource_dbname   => $::icingaweb2::web_db_name,
    resource_username => $::icingaweb2::web_db_user,
    resource_password => $::icingaweb2::web_db_pass,
  }

  icingaweb2::config::resource_database { 'icinga_ido':
    resource_db       => $::icingaweb2::ido_db,
    resource_host     => $::icingaweb2::ido_db_host,
    resource_port     => $::icingaweb2::ido_db_port,
    resource_dbname   => $::icingaweb2::ido_db_name,
    resource_username => $::icingaweb2::ido_db_user,
    resource_password => $::icingaweb2::ido_db_pass,
  }

  # Configure roles.ini
  icingaweb2::config::roles { 'Admins':
    role_users       => $::icingaweb2::admin_users,
    role_permissions => $::icingaweb2::admin_permissions,
  }

  if $::icingaweb2::manage_apache_vhost {
    ::apache::custom_config { 'icingaweb2':
      content => template($::icingaweb2::template_apache),
    }
  }
}
