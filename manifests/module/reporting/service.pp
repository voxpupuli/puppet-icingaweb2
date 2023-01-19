# @summary Installs and configures the reporting scheduler.
#
# @note Only systemd is supported by the Icinga Team and this module.
#
# @param [Stdlib::Ensure::Service] ensure
#   Whether the reporting service should be running.
#
# @param [Boolean] enable
#   Enable or disable the service.
#
# @param [String] user
#   Specifies the user to run the reporting service daemon as.
#   Only available if install_method package is not used.
#
# @param [String] group
#   Specifies the primary group to run the reporting service daemon as.
#   Only available if install_method package is not used.
#
# @param [Boolean] manage_user
#   Whether to manage the server user resource. Only available if
#   install_method package is not used.
#
# @example
#   include icingaweb2::module::reporting::service
#
class icingaweb2::module::reporting::service (
  Stdlib::Ensure::Service $ensure      = 'running',
  Boolean                 $enable      = true,
  String                  $user        = 'icingareporting',
  String                  $group       = 'icingaweb2',
  Boolean                 $manage_user = true,
) {
  require icingaweb2::module::reporting

  $install_method = $icingaweb2::module::reporting::install_method

  if $install_method != 'package' {
    if $manage_user {
      user { $user:
        ensure => 'present',
        gid    => $group,
        shell  => '/bin/false',
        before => Systemd::Unit_file['icinga-reporting.service'],
      }
    }

    systemd::unit_file { 'icinga-reporting.service':
      ensure  => 'present',
      content => epp('icingaweb2/icinga-reporting.service.epp', {
          'conf_user'     => $user,
          'icingacli_bin' => $icingaweb2::globals::icingacli_bin,
      }),
      notify  => Service['icinga-reporting'],
    }
  }

  service { 'icinga-reporting':
    ensure => $ensure,
    enable => $enable,
  }
}
