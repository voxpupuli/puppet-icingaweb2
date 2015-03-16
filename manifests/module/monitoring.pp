# == Class: icingaweb2::module::monitoring
#
class icingaweb2::module::monitoring(
  $ensure = 'enabled'
) {

  $config_dir = "${::icingaweb2::config_dir}/modules/monitoring"

  ::icingaweb2::module { 'monitoring':
    ensure => $ensure,
  }

  if $ensure == 'enabled' {
    Icingaweb2::Module['monitoring'] ->

    # TODO: better implementation
    file { 'icingaweb2-module-monitoring-backends':
      ensure  => file,
      path    => "${config_dir}/backends.ini",
      content => template('icingaweb2/module/monitoring/backends.ini.erb'),
    } ->

    # TODO: better implementation
    file { 'icingaweb2-module-monitoring-instances':
      ensure  => file,
      path    => "${config_dir}/instances.ini",
      content => template('icingaweb2/module/monitoring/instances.ini.erb'),
    }
  }

}
