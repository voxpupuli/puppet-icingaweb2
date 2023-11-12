# @summary
#   Installs the monitoring module.
#
# @api private
#
class icingaweb2::module::monitoring::install {
  assert_private()

  $conf_user  = $icingaweb2::conf_user
  $conf_group = $icingaweb2::conf_group
  $cert_dir   = $icingaweb2::module::monitoring::cert_dir
  $ensure     = $icingaweb2::module::monitoring::ensure
  $use_tls    = $icingaweb2::module::monitoring::use_tls
  $tls        = $icingaweb2::module::monitoring::tls

  icingaweb2::module { 'monitoring':
    ensure         => $ensure,
    install_method => 'none',
  }

  if $use_tls {
    file { $cert_dir:
      ensure => directory,
      owner  => 'root',
      group  => $conf_group,
      mode   => '2770',
    }

    icinga::cert { 'icingaweb2::module::monitoring tls client config':
      owner => $conf_user,
      group => $conf_group,
      args  => $tls,
    }
  }
}
