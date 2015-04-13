#
#
#
#

class icingaweb2::module::monitoring(
  $enabled          = true,
  $backend_type     = 'ido',
  $backend_resource = 'icinga_ido',

#  $config_protected_customvars = "*pw*,*pass*,community",

#[icinga]
#transport           = "local"
#path                = "/var/run/icinga2/cmd/icinga2.cmd"
#  $instance_ = undef
) {

  if( $enabled == true ) {

    class {
      'icingaweb2::modules':
        enabled  => 'monitoring',
        require  => File["${::icingaweb2::config_dir}/modules/monitoring"]
    }

    $backend_ini = "${::icingaweb2::config_dir}/modules/monitoring/backends.ini"

    file {
      "${$backend_ini}":
        ensure => file
    }

    Ini_Setting {
      ensure  => present,
      require => File["${$backend_ini}"],
      path    => "${$backend_ini}"
    }

    ini_setting {
      "icingaweb2 module 'monitoring' type":
        section => 'icinga',
        setting => 'type',
        value   => "\"${backend_type}\"",
    }

    ini_setting {
      "icingaweb2 module 'monitoring' resource":
        section => 'icinga',
        setting => 'resource',
        value   => "\"${backend_resource}\"",
    }


  } else {

    class {
      'icingaweb2::modules':
        disabled => 'monitoring',
        require  => File["${::icingaweb2::config_dir}/modules/monitoring"]
    }

  }

}

# EOF
