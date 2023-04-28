# @summary Installs and configures the x509 job scheduler.
#
# @note Only systemd is supported by the Icinga Team and this module.
#
# @param [Stdlib::Ensure::Service] ensure
#   Whether the x509 service should be running.
#
# @param [Boolean] enable
#   Enable or disable the service.
#
# @example
#   include icingaweb2::module::x509::service
#
class icingaweb2::module::x509::service (
  Stdlib::Ensure::Service $ensure      = 'running',
  Boolean                 $enable      = true,
) {
  require icingaweb2::module::x509

  $install_method = $icingaweb2::module::x509::install_method

  if $install_method != 'package' {
    $_unit_file = if $icingaweb2::module::x509::module_dir {
      "${icingaweb2::module::x509::module_dir}/config/systemd/icinga-x509.service"
    } else {
      "${icingaweb2::globals::default_module_path}/x509/config/systemd/icinga-x509.service"
    }
    systemd::unit_file { 'icinga-x509.service':
      ensure => 'present',
      source => $_unit_file,
      notify => Service['icinga-x509'],
    }
  }

  service { 'icinga-x509':
    ensure => $ensure,
    enable => $enable,
  }
}
