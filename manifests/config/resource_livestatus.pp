# Define for setting IcingaWeb2 LiveStatus
#
define icingaweb2::config::resource_livestatus (
  $resource_name   = $title,
  $resource_socket = undef,
) {
  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/resources.ini"],
    path    => "${::icingaweb2::config_dir}/resources.ini",
  }

  ini_setting { "icingaweb2 resources ${title} type":
    section => $resource_name,
    setting => 'type',
    value   => 'livestatus',
  }

  ini_setting { "icingaweb2 resources ${title} socket":
    section => $resource_name,
    setting => 'socket',
    value   => "\"${resource_socket}\"",
  }
}

