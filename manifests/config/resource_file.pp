# == Define: icingaweb2::config::resource_file
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
define icingaweb2::config::resource_file (
  $resource_filepath = undef,
  $resource_name     = $title,
  $resource_pattern  = undef,
) {
  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/resources.ini"],
    path    => "${::icingaweb2::config_dir}/resources.ini",
  }

  ini_setting { "icingaweb2 resources ${title} type":
    section => $resource_name,
    setting => 'type',
    value   => 'file',
  }

  ini_setting { "icingaweb2 resources ${title} filepath":
    section => $resource_name,
    setting => 'filename',
    value   => "\"${resource_filepath}\"",
  }

  ini_setting { "icingaweb2 resources ${title} fields":
    section => $resource_name,
    setting => 'fields',
    value   => "\"${resource_pattern}\"",
  }
}

