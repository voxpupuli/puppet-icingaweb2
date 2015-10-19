define icingaweb2::config::authentication_ldap (
  $auth_section = undef,
  $auth_resource = undef,
  $backend = 'ldap',
  $user_class = 'inetOrgPerson',
  $filter = '',
  $user_name_attribute = 'uid',
  $base_dn = undef,
){

  Ini_Setting {
    ensure  => present,
    section => $auth_section,
    require => File["${::icingaweb2::config_dir}/authentication.ini"],
    path    => "${::icingaweb2::config_dir}/authentication.ini",
  }

  ini_setting { "icingaweb2 authentication ${title} resource":
    setting => 'resource',
    value   => "\"${auth_resource}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} backend":
    setting => 'backend',
    value   => "\"${backend}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} user_class":
    setting => 'user_class',
    value   => "\"${user_class}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} filter":
    setting => 'filter',
    value   => "\"${filter}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} user_name_attribute":
    setting => 'user_name_attribute',
    value   => "\"${user_name_attribute}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} base_dn":
    setting => 'base_dn',
    value   => "\"${base_dn}\"",
  }


}

