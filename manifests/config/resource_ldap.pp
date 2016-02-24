# Define for setting IcingaWeb2 LDAP Resource
#
define icingaweb2::config::resource_ldap (
  $resource_bind_dn    = undef,
  $resource_bind_pw    = undef,
  $resource_host       = undef,
  $resource_name       = $title,
  $resource_port       = undef,
  $resource_root_dn    = undef,
  $resource_encryption = undef,
) {
  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/resources.ini"],
    path    => "${::icingaweb2::config_dir}/resources.ini",
  }

  ini_setting { "icingaweb2 resources ${title} type":
    section => $resource_name,
    setting => 'type',
    value   => 'ldap',
  }

  ini_setting { "icingaweb2 resources ${title} hostname":
    section => $resource_name,
    setting => 'hostname',
    value   => "\"${resource_host}\"",
  }

  ini_setting { "icingaweb2 resources ${title} port":
    section => $resource_name,
    setting => 'port',
    value   => "\"${resource_port}\"",
  }

  ini_setting { "icingaweb2 resources ${title} root_dn":
    section => $resource_name,
    setting => 'root_dn',
    value   => "\"${resource_root_dn}\"",
  }

  ini_setting { "icingaweb2 resources ${title} bind_dn":
    section => $resource_name,
    setting => 'bind_dn',
    value   => "\"${resource_bind_dn}\"",
  }

  ini_setting { "icingaweb2 resources ${title} bind_pw":
    section => $resource_name,
    setting => 'bind_pw',
    value   => "\"${resource_bind_pw}\"",
  }

  ini_setting { "icingaweb2 resources ${title} encryption":
    section => $resource_name,
    setting => 'encryption',
    value   => "\"${resource_encryption}\"",
  }
}

