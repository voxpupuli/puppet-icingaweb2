# @summary Installs and configures the vspheredb service.
#
# @note Only systemd is supported by the Icinga Team and this module.
#
# @param [Stdlib::Ensure::Service] ensure
#   Whether the vspheredb service should be running.
# @param [Boolean] enable
#   Enable or disable the service.
# @param [String] user
#   Specifies the user to run the vsphere service daemon as.
# @param [String] group
#   Specifies the primary group to run the vspheredb service daemon as.
# @param [Boolean] manage_user
#   Whether to manage the server user resource.
#
# @example
#   include icingaweb2::module::vspheredb::service
#
class icingaweb2::module::vspheredb::service (
  Stdlib::Ensure::Service $ensure      = 'running',
  Boolean                 $enable      = true,
  String                  $user        = 'icingavspheredb',
  String                  $group       = 'icingaweb2',
  Boolean                 $manage_user = true,
) {

  require ::icingaweb2::module::vspheredb

  if $manage_user {
    user { $user:
      ensure => 'present',
      gid    => $group,
      shell  => '/bin/false',
      before => Systemd::Unit_file['icinga-vspheredb.service'],
    }
  }

  systemd::unit_file { 'icinga-vspheredb.service':
    ensure  => 'present',
    content => epp('icingaweb2/icinga-vspheredb.service.epp', {
      'conf_user'     => $icingaweb2::conf_user,
      'icingacli_bin' => $icingaweb2::globals::icingacli_bin,
    }),
    notify  => Service['icinga-vspheredb'],
  }

  service {'icinga-vspheredb':
    ensure => $ensure,
    enable => $enable,
  }
}
