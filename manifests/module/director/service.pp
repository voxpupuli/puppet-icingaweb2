# @summary
#   Installs and configures the director service.
#
# @note Only systemd is supported by the Icinga Team and this module.
#
# @param ensure
#   Whether the director service should be running.
#
# @param enable
#   Enable or disable the service.
#
# @param user
#   Specifies user to run director service daemon. Only available if
#   install_method package is not used.
#
# @param group
#   Specifies primary group for user to run director service daemon.
#    Only available if install_method package is not used.
#
# @param manage_user
#   Whether to manage the server user resource. Only available if
#   install_method package is not used.
#
class icingaweb2::module::director::service(
  Stdlib::Ensure::Service   $ensure      = 'running',
  Boolean                   $enable      = true,
  String                    $user        = 'icingadirector',
  String                    $group       = 'icingaweb2',
  Boolean                   $manage_user = true,
) {

  require ::icingaweb2::module::director

  $icingacli_bin  = $::icingaweb2::globals::icingacli_bin
  $install_method = $::icingaweb2::module::director::install_method

  if $install_method != 'package' {
    if $manage_user {
      user { $user:
        ensure => present,
        gid    => $group,
        shell  => '/bin/false',
        before => Systemd::Unit_file['icinga-director.service'],
      }
    }

    systemd::unit_file { 'icinga-director.service':
      content => template('icingaweb2/icinga-director.service.erb'),
      notify  => Service['icinga-director'],
    }
  }

  service {'icinga-director':
    ensure => $ensure,
    enable => $enable,
  }
}
