# Define for setting IcingaWeb2 Database Resource
#
define icingaweb2::config::resource_database (
  $resource_db       = undef,
  $resource_dbname   = undef,
  $resource_host     = undef,
  $resource_name     = $title,
  $resource_password = undef,
  $resource_port     = undef,
  $resource_username = undef,
) {
  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/resources.ini"],
    path    => "${::icingaweb2::config_dir}/resources.ini",
  }

  ini_setting { "icingaweb2 resources ${title} type":
    section => $resource_name,
    setting => 'type',
    value   => 'db',
  }

  ini_setting { "icingaweb2 resources ${title} db":
    section => $resource_name,
    setting => 'db',
    value   => "\"${resource_db}\"",
  }

  ini_setting { "icingaweb2 resources ${title} host":
    section => $resource_name,
    setting => 'host',
    value   => "\"${resource_host}\"",
  }

  ini_setting { "icingaweb2 resources ${title} port":
    section => $resource_name,
    setting => 'port',
    value   => "\"${resource_port}\"",
  }

  ini_setting { "icingaweb2 resources ${title} dbname":
    section => $resource_name,
    setting => 'dbname',
    value   => "\"${resource_dbname}\"",
  }

  ini_setting { "icingaweb2 resources ${title} username":
    section => $resource_name,
    setting => 'username',
    value   => "\"${resource_username}\"",
  }

  ini_setting { "icingaweb2 resources ${title} password":
    section => $resource_name,
    setting => 'password',
    value   => "\"${resource_password}\"",
  }
}

