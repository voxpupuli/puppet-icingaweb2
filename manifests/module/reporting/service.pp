# @summary
#   Manage the reporting service.
#
# @api private
#
class icingaweb2::module::reporting::service {
  assert_private()

  if $icingaweb2::module::reporting::manage_service {
    $ensure = $icingaweb2::module::reporting::service_ensure
    $enable = $icingaweb2::module::reporting::service_enable

    service { 'icinga-reporting':
      ensure => $ensure,
      enable => $enable,
    }
  }
}
