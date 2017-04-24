# == Class: icingaweb2
#
#
#
# === Parameters
#
# === Variables
#
# === Examples
#
#

#This module installs and configures Icinga Web 2.
class icingaweb2 (
  $admin_permissions                 = $::icingaweb2::params::admin_permissions,
  $admin_users                       = $::icingaweb2::params::admin_users,
  $auth_backend                      = $::icingaweb2::params::auth_backend,
  $auth_ldap_base_dn                 = $::icingaweb2::params::auth_ldap_base_dn,
  $auth_ldap_filter                  = $::icingaweb2::params::auth_ldap_filter,
  $auth_ldap_user_class              = $::icingaweb2::params::auth_ldap_user_class,
  $auth_ldap_user_name_attribute     = $::icingaweb2::params::auth_ldap_user_name_attribute,
  $auth_resource                     = $::icingaweb2::params::auth_resource,
  $config_dir                        = $::icingaweb2::params::config_dir,
  $config_dir_mode                   = $::icingaweb2::params::config_dir_mode,
  $config_dir_purge                  = $::icingaweb2::params::config_dir_purge,
  $config_dir_recurse                = $::icingaweb2::params::config_dir_recurse,
  $config_file_mode                  = $::icingaweb2::params::config_file_mode,
  $config_group                      = $::icingaweb2::params::config_group,
  $config_user                       = $::icingaweb2::params::config_user,
  $git_repo                          = $::icingaweb2::params::git_repo,
  $git_revision                      = $::icingaweb2::params::git_revision,
  $ido_db                            = $::icingaweb2::params::ido_db,
  $ido_db_host                       = $::icingaweb2::params::ido_db_host,
  $ido_db_name                       = $::icingaweb2::params::ido_db_name,
  $ido_db_pass                       = $::icingaweb2::params::ido_db_pass,
  $ido_db_port                       = $::icingaweb2::params::ido_db_port,
  $ido_db_user                       = $::icingaweb2::params::ido_db_user,
  $ido_type                          = $::icingaweb2::params::ido_type,
  $install_method                    = $::icingaweb2::params::install_method,
  $ldap_bind_dn                      = $::icingaweb2::params::ldap_bind_dn,
  $ldap_bind_pw                      = $::icingaweb2::params::ldap_bind_pw,
  $ldap_encryption                   = $::icingaweb2::params::ldap_encryption,
  $ldap_host                         = $::icingaweb2::params::ldap_host,
  $ldap_port                         = $::icingaweb2::params::ldap_port,
  $ldap_root_dn                      = $::icingaweb2::params::ldap_root_dn,
  $log_application                   = $::icingaweb2::params::log_application,
  $log_level                         = $::icingaweb2::params::log_level,
  $log_method                        = $::icingaweb2::params::log_method,
  $log_resource                      = $::icingaweb2::params::log_resource,
  $log_store                         = $::icingaweb2::params::log_store,
  $manage_apache_vhost               = $::icingaweb2::params::manage_apache_vhost,
  $manage_repo                       = false,
  $manage_user                       = $::icingaweb2::params::manage_user,
  $pkg_deps                          = $::icingaweb2::params::pkg_deps,
  $pkg_ensure                        = $::icingaweb2::params::pkg_ensure,
  $pkg_list                          = $::icingaweb2::params::pkg_list,
  $pkg_repo_release_key              = undef, # Deprecated
  $pkg_repo_release_metadata_expire  = undef, # Deprecated
  $pkg_repo_release_url              = undef, # Deprecated
  $pkg_repo_snapshot_key             = undef, # Deprecated
  $pkg_repo_snapshot_metadata_expire = undef, # Deprecated
  $pkg_repo_snapshot_url             = undef, # Deprecated
  $pkg_repo_version                  = undef, # Deprecated
  $template_auth                     = $::icingaweb2::params::template_auth,
  $template_config                   = $::icingaweb2::params::template_config,
  $template_resources                = $::icingaweb2::params::template_resources,
  $template_roles                    = $::icingaweb2::params::template_roles,
  $template_apache                   = $::icingaweb2::params::template_apache,
  $web_db                            = $::icingaweb2::params::web_db,
  $web_db_host                       = $::icingaweb2::params::web_db_host,
  $web_db_name                       = $::icingaweb2::params::web_db_name,
  $web_db_pass                       = $::icingaweb2::params::web_db_pass,
  $web_db_port                       = $::icingaweb2::params::web_db_port,
  $web_db_prefix                     = $::icingaweb2::params::web_db_prefix,
  $web_db_user                       = $::icingaweb2::params::web_db_user,
  $web_root                          = $::icingaweb2::params::web_root,
  $web_type                          = $::icingaweb2::params::web_type,
  $initialize                        = $::icingaweb2::params::initialize,
) inherits ::icingaweb2::params {
  class { '::icingaweb2::repo': } ->
  class { '::icingaweb2::install': } ->
  class { '::icingaweb2::config': } ->
  class { '::icingaweb2::initialize': } ->
  Class['::icingaweb2']

  validate_absolute_path($config_dir)
  validate_absolute_path($web_root)
  validate_array($pkg_deps)
  validate_array($pkg_list)
  validate_bool($config_dir_recurse)
  validate_bool($manage_repo)
  validate_bool($manage_user)
  validate_bool($initialize)
  validate_slength($config_dir_mode, 4)
  validate_slength($config_file_mode, 4)
  validate_string($admin_permissions)
  validate_string($admin_users)
  validate_string($auth_backend)
  validate_string($auth_resource)
  validate_string($config_dir_mode)
  validate_string($config_file_mode)
  validate_string($config_group)
  validate_string($config_user)
  validate_string($log_application)
  validate_string($log_level)
  validate_string($log_method)
  validate_string($log_resource)
  validate_string($log_store)
  validate_string($pkg_ensure)
  validate_string($template_auth)
  validate_string($template_config)
  validate_string($template_resources)
  validate_string($template_roles)

  if $::icingaweb2::auth_backend == 'ldap' {
    validate_integer($ldap_port)
    validate_string($auth_ldap_base_dn)
    validate_string($auth_ldap_filter)
    validate_string($auth_ldap_user_class)
    validate_string($auth_ldap_user_name_attribute)
    validate_string($ldap_host)
    validate_string($ldap_bind_dn)
    validate_string($ldap_bind_pw)
    validate_string($ldap_root_dn)
    if $::icingaweb2::ldap_encryption {
      validate_re( $ldap_encryption, '^(ldaps|starttls)$', "\$ldap_encryption must be either 'ldaps' or 'starttls', got '${ldap_encryption}'")
    }
  }

  if $::icingaweb2::manage_apache_vhost {
    validate_string($template_apache)
  }

  validate_re($install_method,
    [
      'git',
      'package',
    ]
  )

  validate_re($pkg_ensure,
    [
      'absent',
      'latest',
      'present',
      'purged',
    ]
  )
}
