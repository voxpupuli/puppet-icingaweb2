# Define for setting IcingaWeb2 Roles
#
define icingaweb2::config::roles (
  $role_groups         = undef,
  $role_host_filter    = absent,
  $role_name           = $title,
  $role_permissions    = undef,
  $role_service_filter = absent,
  $role_users          = undef,
) {
  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/roles.ini"],
    path    => "${::icingaweb2::config_dir}/roles.ini",
  }

  if $role_users {
    ini_setting { "icingaweb2 roles ${title} users":
      section => $role_name,
      setting => 'users',
      value   => "\"${role_users}\"",
    }
  } else {
    ini_setting { "icingaweb2 roles ${title} users":
      ensure  => absent,
      section => $role_name,
      setting => 'users',
    }
  }

  if $role_groups {
    ini_setting { "icingaweb2 roles ${title} groups":
      section => $role_name,
      setting => 'groups',
      value   => "\"${role_groups}\"",
    }
  } else {
    ini_setting { "icingaweb2 roles ${title} groups":
      ensure  => absent,
      section => $role_name,
      setting => 'groups',
    }

  }

  if $role_permissions {
    ini_setting { "icingaweb2 roles ${title} permissions":
      section => $role_name,
      setting => 'permissions',
      value   => "\"${role_permissions}\"",
    }
  } else {
    ini_setting { "icingaweb2 roles ${title} permissions":
      ensure  => absent,
      section => $role_name,
      setting => 'permissions',
    }
  }

  if $role_host_filter {
    ini_setting { "icingaweb2 roles ${title} host filter":
      section => $role_name,
      setting => 'monitoring/hosts/filter',
      value   => "\"${role_host_filter}\"",
    }
  } else {
    ini_setting { "icingaweb2 roles ${title} host filter":
      ensure  => absent,
      section => $role_name,
      setting => 'monitoring/hosts/filter',
    }
  }

  if $role_service_filter {
    ini_setting { "icingaweb2 roles ${title} service filter":
      section => $role_name,
      setting => 'monitoring/services/filter',
      value   => "\"${role_service_filter}\"",
    }
  } else {
    ini_setting { "icingaweb2 roles ${title} service filter":
      ensure  => absent,
      section => $role_name,
      setting => 'monitoring/services/filter',
    }
  }
}

