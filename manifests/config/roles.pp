# Define for setting IcingaWeb2 Roles 

define icingaweb2::config::roles (
  $role_name           = $title,
  $role_users          = undef,
  $role_groups         = undef,
  $role_permissions    = undef,
  $role_host_filter    = undef,
  $role_service_filter = undef,
) {

  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/roles.ini"],
    path    => "${::icingaweb2::config_dir}/roles.ini",
  }

  ini_setting { "icingaweb2 roles ${title} users":
    section => $role_name,
    setting => 'users',
    value   => "\"${role_users}\"",
  }

  ini_setting { "icingaweb2 roles ${title} groups":
    section => $role_name,
    setting => 'groups',
    value   => "\"${role_groups}\"",
  }

  ini_setting { "icingaweb2 roles ${title} permissions":
    section => $role_name,
    setting => 'permissions',
    value   => "\"${role_permissions}\"",
  }

  ini_setting { "icingaweb2 roles ${title} host filter":
    section => $role_name,
    setting => 'monitoring/hosts/filter',
    value   => "\"${role_host_filter}\"",
  }

  ini_setting { "icingaweb2 roles ${title} service filter":
    section => $role_name,
    setting => 'monitoring/services/filter',
    value   => "\"${role_service_filter}\"",
  }
}
