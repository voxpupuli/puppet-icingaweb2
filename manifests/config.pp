# == Class: icingaweb2::config
#
#
#
# === Parameters
#
# === Variables
#
# === Examples
#
# This class is private and should not be called by others than this module.
#
class icingaweb2::config (
  $config_dir       = $::icingaweb2::config_dir,
  $config_dir_purge = $::icingaweb2::config_dir_purge,
) {

  File {
    require => Class['::icingaweb2::install'],
    owner => $::icingaweb2::config_user,
    group => $::icingaweb2::config_group,
    mode  => '0660',
  }

  file {
    $::icingaweb2::config_dir:
      ensure  => directory,
      purge   => $::icingaweb2::config_dir_purge;

    "${::icingaweb2::config_dir}/enabledModules":
      ensure => directory,
      mode   => '2750';

    "${::icingaweb2::config_dir}/modules":
      ensure => directory,
      mode   => '2770';

    "${::icingaweb2::config_dir}/authentication.ini":
      ensure => file;

    "${::icingaweb2::config_dir}/config.ini":
      ensure => file
      ;

    "${::icingaweb2::config_dir}/resources.ini":
      ensure => file;

    "${::icingaweb2::config_dir}/roles.ini":
      ensure => file;

    "${::icingaweb2::config_dir}/groups.ini":
      ensure => file,
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
    'ldap': {
      icingaweb2::config::authentication_ldap { 'LDAP Authentication':
        auth_section        => 'icingaweb2',
        auth_resource       => 'ldap',
        user_class          => $::icingaweb2::auth_ldap_user_class,
        user_name_attribute => $::icingaweb2::auth_ldap_user_name_attribute,
        filter              => $::icingaweb2::auth_ldap_filter,
        base_dn             => $::icingaweb2::auth_ldap_base_dn,
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

  if $::icingaweb2::auth_backend == 'ldap' {
    icingaweb2::config::resource_ldap { 'ldap':
      resource_host       => $::icingaweb2::ldap_host,
      resource_bind_dn    => $::icingaweb2::ldap_bind_dn,
      resource_bind_pw    => $::icingaweb2::ldap_bind_pw,
      resource_port       => $::icingaweb2::ldap_port,
      resource_root_dn    => $::icingaweb2::ldap_root_dn,
      resource_encryption => $::icingaweb2::ldap_encryption,
    }
  }

  # Configure roles.ini
  icingaweb2::config::roles { 'Admins':
    role_users       => $::icingaweb2::admin_users,
    role_permissions => $::icingaweb2::admin_permissions,
  }
}
