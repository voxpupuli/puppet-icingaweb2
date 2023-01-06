# @summary Installs and configures the vspheredb service.
#
# @note Only systemd is supported by the Icinga Team and this module.
#
# @param [Stdlib::Ensure::Service] ensure
#   Whether the vspheredb service should be running.
#
# @param [Boolean] enable
#   Enable or disable the service.
#
# @param [String] user
#   Specifies the user to run the vsphere service daemon as.
#   Only available if install_method package is not used.
#
# @param [String] group
#   Specifies the primary group to run the vspheredb service daemon as.
#   Only available if install_method package is not used.
#
# @param [Boolean] manage_user
#   Whether to manage the server user resource. Only available if
#   install_method package is not used.
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
  require icingaweb2::module::vspheredb

  $install_method = $icingaweb2::module::vspheredb::install_method

  if $install_method != 'package' {
    if $manage_user {
      user { $user:
        ensure => 'present',
        gid    => $group,
        shell  => '/bin/false',
        before => [Systemd::Unit_file['icinga-vspheredb.service'], Systemd::Tmpfile['icinga-vspheredb.conf']],
      }
    }

    systemd::tmpfile { 'icinga-vspheredb.conf':
      content => "d /run/icinga-vspheredb 0755 ${user} ${group} -",
      before  => Systemd::Unit_file['icinga-vspheredb.service'],
    }

    systemd::unit_file { 'icinga-vspheredb.service':
      ensure  => 'present',
      content => epp('icingaweb2/icinga-vspheredb.service.epp', {
          'conf_user'     => $user,
          'icingacli_bin' => $icingaweb2::globals::icingacli_bin,
      }),
      notify  => Service['icinga-vspheredb'],
    }
  }

  service { 'icinga-vspheredb':
    ensure => $ensure,
    enable => $enable,
  }
}
