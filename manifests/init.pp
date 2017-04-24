# == Class: icingaweb2
#
# This module installs and configures Icinga Web 2.
#
# === Parameters
#
# [*manage_repo*]
#   When set to true this module will install the packages.icinga.com repository. With this official repo you can get
#   the latest version of Icinga Web. When set to false the operating systems default will be used. Defaults to false.
#   NOTE: will be ignored if manage_package is set to false.
#
# [*manage_package*]
#   If set to false packages aren't managed. Defaults to true.
#
# === Variables
#
# === Examples
#
#

#This module installs and configures Icinga Web 2.
class icingaweb2 (
  $manage_repo                       = false,
  $manage_package                    = true,
  $admin_permissions                 = $::icingaweb2::params::admin_permissions,
  $admin_users                       = $::icingaweb2::params::admin_users,
  $auth_backend                      = $::icingaweb2::params::auth_backend,
  $auth_ldap_base_dn                 = $::icingaweb2::params::auth_ldap_base_dn,
  $auth_ldap_filter                  = $::icingaweb2::params::auth_ldap_filter,
  $auth_ldap_user_class              = $::icingaweb2::params::auth_ldap_user_class,
  $auth_ldap_user_name_attribute     = $::icingaweb2::params::auth_ldap_user_name_attribute,
  $auth_resource                     = $::icingaweb2::params::auth_resource,
  $config_dir                        = $::icingaweb2::params::config_dir,
  $config_dir_purge                  = $::icingaweb2::params::config_dir_purge,
  $config_group                      = $::icingaweb2::params::config_group,
  $config_user                       = $::icingaweb2::params::config_user,
  $ido_db                            = $::icingaweb2::params::ido_db,
  $ido_db_host                       = $::icingaweb2::params::ido_db_host,
  $ido_db_name                       = $::icingaweb2::params::ido_db_name,
  $ido_db_pass                       = $::icingaweb2::params::ido_db_pass,
  $ido_db_port                       = $::icingaweb2::params::ido_db_port,
  $ido_db_user                       = $::icingaweb2::params::ido_db_user,
  $ido_type                          = $::icingaweb2::params::ido_type,
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
  $template_auth                     = $::icingaweb2::params::template_auth,
  $template_config                   = $::icingaweb2::params::template_config,
  $template_resources                = $::icingaweb2::params::template_resources,
  $template_roles                    = $::icingaweb2::params::template_roles,
  $web_db                            = $::icingaweb2::params::web_db,
  $web_db_host                       = $::icingaweb2::params::web_db_host,
  $web_db_name                       = $::icingaweb2::params::web_db_name,
  $web_db_pass                       = $::icingaweb2::params::web_db_pass,
  $web_db_port                       = $::icingaweb2::params::web_db_port,
  $web_db_prefix                     = $::icingaweb2::params::web_db_prefix,
  $web_db_user                       = $::icingaweb2::params::web_db_user,
  $initialize                        = $::icingaweb2::params::initialize,
) inherits ::icingaweb2::params {

  validate_absolute_path($config_dir)
  validate_bool($manage_repo)
  validate_bool($manage_package)
  validate_bool($initialize)
  validate_string($admin_permissions)
  validate_string($admin_users)
  validate_string($auth_backend)
  validate_string($auth_resource)
  validate_string($config_group)
  validate_string($config_user)
  validate_string($log_application)
  validate_string($log_level)
  validate_string($log_method)
  validate_string($log_resource)
  validate_string($log_store)
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

  class { '::icingaweb2::repo': }
  -> class { '::icingaweb2::install': }
  -> class { '::icingaweb2::config': }
  -> class { '::icingaweb2::initialize': }

}
