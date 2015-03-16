# Define for setting IcingaWeb2 Authentication

define icingaweb2::config::authentication_external (
  $auth_section = undef,
  $auth_filter  = undef,
) {

  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/authentication.ini"],
    path    => "${::icingaweb2::config_dir}/authentication.ini",
  }

  ini_setting { "icingaweb2 authentication ${title} filter":
    section => "$auth_section",
    setting => 'strip_username_regexp',
    value   => "\"$auth_filter\"",
  }

  ini_setting { "icingaweb2 authentication ${title} backend":
    section => "$auth_section",
    setting => 'backend',
    value   => '"external"', 
  }
}
