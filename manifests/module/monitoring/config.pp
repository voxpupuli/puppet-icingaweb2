# @summary
#   Configure the monitoring module.
#
# @api private
#
class icingaweb2::module::monitoring::config {
  assert_private()

  $settings          = $icingaweb2::module::monitoring::settings
  $db                = $icingaweb2::module::monitoring::db
  $db_charset        = $icingaweb2::module::monitoring::ido_db_charset
  $db_resource       = $icingaweb2::module::monitoring::ido_resource_name
  $commandtransports = $icingaweb2::module::monitoring::commandtransports
  $use_tls           = $icingaweb2::module::monitoring::use_tls
  $tls               = $icingaweb2::module::monitoring::tls + {
    cacert_file => icingaweb2::pick($icingaweb2::module::monitoring::tls['cacert_file'], $icingaweb2::config::tls['cacert_file']),
    capath      => icingaweb2::pick($icingaweb2::module::monitoring::tls_capath, $icingaweb2::config::tls['capath']),
    noverify    => icingaweb2::pick($icingaweb2::module::monitoring::tls_noverify, $icingaweb2::config::tls['noverify']),
    cipher      => icingaweb2::pick($icingaweb2::module::monitoring::tls_cipher, $icingaweb2::config::tls['cipher']),
  }

  icingaweb2::resource::database { $db_resource:
    type         => $db['type'],
    host         => $db['host'],
    port         => $db['port'],
    database     => $db['database'],
    username     => $db['username'],
    password     => $db['password'],
    charset      => $db_charset,
    use_tls      => $use_tls,
    tls_noverify => $tls['noverify'],
    tls_key      => $tls['key_file'],
    tls_cert     => $tls['cert_file'],
    tls_cacert   => $tls['cacert_file'],
    tls_capath   => $tls['capath'],
    tls_cipher   => $tls['cipher'],
  }

  create_resources('icingaweb2::inisection', $settings)
  create_resources('icingaweb2::module::monitoring::commandtransport', $commandtransports)
}
