# Define for setting IcingaWeb2 ssh Resource
#
define icingaweb2::config::resource_ssh (
  $resource_user        = undef,
  $resource_private_key = undef,
  $resource_name        = $title,

) {
  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/resources.ini"],
    path    => "${::icingaweb2::config_dir}/resources.ini",
  }

  ini_setting { "icingaweb2 resources ${title} type":
    section => $resource_name,
    setting => 'type',
    value   => 'ssh',
  }

  ini_setting { "icingaweb2 resources ${title} db":
    section => $resource_name,
    setting => 'private_key',
    value   => "\"${resource_private_key}\"",
  }

  ini_setting { "icingaweb2 resources ${title} host":
    section => $resource_name,
    setting => 'user',
    value   => "\"${resource_user}\"",
  }
}

