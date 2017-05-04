# == Define: icingaweb2::config::group_ldap
#
# Sets up an authentication definition for LDAP.
#
define icingaweb2::config::group_ldap (
  $auth_section = undef,
  $auth_resource = undef,
  $user_backend = 'icingaweb2',
  $filter = '',
  $group_name_attribute = 'gid',
  $base_dn = undef,
){

  Ini_Setting {
    ensure  => present,
    section => $auth_section,
    require => File["${::icingaweb2::config_dir}/groups.ini"],
    path    => "${::icingaweb2::config_dir}/groups.ini",
  }

  ini_setting { "icingaweb2 authentication ${title} resource":
    setting => 'resource',
    value   => "\"${auth_resource}\"",
  }

  ini_setting { "icingaweb2 user ${title} backend":
    setting => 'user_backend',
    value   => "\"${user_backend}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} filter":
    setting => 'filter',
    value   => "\"${filter}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} user_name_attribute":
    setting => 'group_name_attribute',
    value   => "\"${group_name_attribute}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} base_dn":
    setting => 'base_dn',
    value   => "\"${base_dn}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} backend":
    setting => 'backend',
    value   => "ldap",
  }
}
