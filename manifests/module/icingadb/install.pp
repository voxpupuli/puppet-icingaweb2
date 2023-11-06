# @summary
#   Install the icingadb module.
#
# @api private
#
class icingaweb2::module::icingadb::install {
  assert_private()

  $conf_user       = $icingaweb2::conf_user
  $conf_group      = $icingaweb2::conf_group
  $ensure          = $icingaweb2::module::icingadb::ensure
  $package_name    = $icingaweb2::module::icingadb::package_name
  $cert_dir        = $icingaweb2::module::icingadb::cert_dir
  $redis_use_tls   = $icingaweb2::module::icingadb::redis_use_tls
  $redis_tls       = $icingaweb2::module::icingadb::redis_tls
  $db_use_tls      = $icingaweb2::module::icingadb::db_use_tls
  $db_tls          = $icingaweb2::module::icingadb::db_tls

  icingaweb2::module { 'icingadb':
    ensure         => $ensure,
    install_method => 'package',
    package_name   => $package_name,
  }

  file { $cert_dir:
    ensure => directory,
    owner  => 'root',
    group  => $conf_group,
    mode   => '2770',
  }

  if $redis_use_tls {
    icinga::cert { 'icingaweb2::module::icingadb redis client tls config':
      owner => $conf_user,
      group => $conf_group,
      args  => $redis_tls,
    }
  }

  if $db_use_tls {
    icinga::cert { 'icingaweb2::module::icingadb database tls client config':
      owner => $conf_user,
      group => $conf_group,
      args  => $db_tls,
    }
  }
}
