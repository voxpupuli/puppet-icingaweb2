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

    icingaweb2::modules {
      'enable monitoring':
        enabled  => [ 'monitoring' ],
        require  => File["${::icingaweb2::config_dir}/modules/monitoring"]
    }

    file {
      "${::icingaweb2::config_dir}/modules/monitoring/backends.ini":
        ensure => file,
        content => template( 'icingaweb2/modules/monitoring/backends.ini.erb' )
    }

  } else {

    icingaweb2::modules {
      'disable monitoring':
        disabled => [ 'monitoring' ],
        require  => File["${::icingaweb2::config_dir}/modules/monitoring"]
    }

  }

}

# EOF
