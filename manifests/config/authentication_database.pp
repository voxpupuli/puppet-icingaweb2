# Define for setting IcingaWeb2 Authentication

define icingaweb2::config::authentication_database (
  $auth_section  = undef,
  $auth_resource = undef,
) {

  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/authentication.ini"],
    path    => "${::icingaweb2::config_dir}/authentication.ini",
  }

  ini_setting { "icingaweb2 authentication ${title} resource":
    section => "$auth_section",
    setting => 'resource',
    value   => "\"$auth_resource\"",
  }

  ini_setting { "icingaweb2 authentication ${title} backend":
    section => "$auth_section",
    setting => 'backend',
    value   => '"db"', 
  }
}
