# @summary
#   Manage the x509 job scheduler.
#
# @api private
#
class icingaweb2::module::x509::service {
  assert_private()

  if $icingaweb2::module::x509::manage_service {
    $ensure = $icingaweb2::module::x509::service_ensure
    $enable = $icingaweb2::module::x509::service_enable

    service { 'icinga-x509':
      ensure => $ensure,
      enable => $enable,
    }
  }
}
