# Define for setting IcingaWeb2 Groups
#
define icingaweb2::config::groups_database (
  $groups_resource = undef,
  $groups_section  = undef,
) {
  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/groups.ini"],
    path    => "${::icingaweb2::config_dir}/groups.ini",
  }

  ini_setting { "icingaweb2 groups ${title} resource":
    section => $groups_section,
    setting => 'resource',
    value   => "\"${groups_resource}\"",
  }

  ini_setting { "icingaweb2 groups ${title} backend":
    section => $groups_section,
    setting => 'backend',
    value   => '"db"',
  }
}
