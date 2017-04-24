# == Define: icingaweb2::config::roles
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
define icingaweb2::config::roles (
  $role_groups         = undef,
  $role_host_filter    = undef,
  $role_name           = $title,
  $role_permissions    = undef,
  $role_service_filter = undef,
  $role_users          = undef,
) {
  validate_string($role_name)

  Ini_Setting {
    ensure  => present,
    section => $role_name,
    require => File["${::icingaweb2::config_dir}/roles.ini"],
    path    => "${::icingaweb2::config_dir}/roles.ini",
  }

  if $role_users {
    validate_string($role_users)
    $role_users_ensure = present
  }
  else {
    $role_users_ensure = absent
  }

  ini_setting { "icingaweb2 roles ${title} users":
    ensure  => $role_users_ensure,
    setting => 'users',
    value   => "\"${role_users}\"",
  }

  if $role_groups {
    validate_string($role_users)
    $role_groups_ensure = present
  }
  else {
    $role_groups_ensure = absent
  }

  ini_setting { "icingaweb2 roles ${title} groups":
    ensure  => $role_groups_ensure,
    setting => 'groups',
    value   => "\"${role_groups}\"",
  }

  if $role_permissions {
    validate_string($role_permissions)
    $role_permissions_ensure = present
  }
  else {
    $role_permissions_ensure = absent
  }

  ini_setting { "icingaweb2 roles ${title} permissions":
    ensure  => $role_permissions_ensure,
    setting => 'permissions',
    value   => "\"${role_permissions}\"",
  }

  if $role_host_filter {
    validate_string($role_host_filter)
    $role_host_filter_ensure = present
  }
  else {
    $role_host_filter_ensure = absent
  }

  ini_setting { "icingaweb2 roles ${title} host filter":
    ensure  => $role_host_filter_ensure,
    setting => 'monitoring/hosts/filter',
    value   => "\"${role_host_filter}\"",
  }

  if $role_service_filter {
    validate_string($role_service_filter)
    $role_service_filter_ensure = present
  }
  else {
    $role_service_filter_ensure = absent
  }

  ini_setting { "icingaweb2 roles ${title} service filter":
    ensure  => $role_service_filter_ensure,
    setting => 'monitoring/services/filter',
    value   => "\"${role_service_filter}\"",
  }
}

