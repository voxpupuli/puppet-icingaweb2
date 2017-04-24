# == Define: icingaweb2::config::authentication_database
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
define icingaweb2::config::authentication_database (
  $auth_resource = undef,
  $auth_section  = undef,
) {
  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/authentication.ini"],
    path    => "${::icingaweb2::config_dir}/authentication.ini",
  }

  ini_setting { "icingaweb2 authentication ${title} resource":
    section => $auth_section,
    setting => 'resource',
    value   => "\"${auth_resource}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} backend":
    section => $auth_section,
    setting => 'backend',
    value   => '"db"',
  }
}

