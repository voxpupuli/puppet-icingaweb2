# @summary
#   Manage the director service.
#
# @api private
#
class icingaweb2::module::director::service {
  assert_private()

  if $icingaweb2::module::director::manage_service {
    $ensure = $icingaweb2::module::director::service_ensure
    $enable = $icingaweb2::module::director::service_enable

    service { 'icinga-director':
      ensure => $ensure,
      enable => $enable,
    }
  }
}
