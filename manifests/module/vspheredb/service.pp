# @summary
#   Manage the vspheredb service.
#
# @api private
#
class icingaweb2::module::vspheredb::service {
  assert_private()

  if $icingaweb2::module::vspheredb::manage_service {
    $ensure = $icingaweb2::module::vspheredb::service_ensure
    $enable = $icingaweb2::module::vspheredb::service_enable

    service { 'icinga-vspheredb':
      ensure => $ensure,
      enable => $enable,
    }
  }
}
