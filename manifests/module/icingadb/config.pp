# @summary
#   Configure the icingadb module.
#
# @api private
#
class icingaweb2::module::icingadb::config {
  assert_private()

  $ensure            = $icingaweb2::module::icingadb::ensure
  $module_conf_dir   = "${icingaweb2::globals::conf_dir}/modules/icingadb"
  $db_type           = $icingaweb2::module::icingadb::db_type
  $db_host           = $icingaweb2::module::icingadb::db_host
  $db_port           = $icingaweb2::module::icingadb::db_port
  $db_name           = $icingaweb2::module::icingadb::db_name
  $db_username       = $icingaweb2::module::icingadb::db_username
  $db_password       = $icingaweb2::module::icingadb::db_password
  $db_charset        = $icingaweb2::module::icingadb::db_charset
  $db_use_tls        = $icingaweb2::module::icingadb::db_use_tls
  $db_tls            = $icingaweb2::module::icingadb::db_tls + {
    cacert_file => icingaweb2::pick($icingaweb2::module::icingadb::db_tls['cacert_file'], $icingaweb2::config::tls['cacert_file']),
    capath      => icingaweb2::pick($icingaweb2::module::icingadb::db_tls_capath, $icingaweb2::config::tls['capath']),
    noverify    => icingaweb2::pick($icingaweb2::module::icingadb::db_tls_noverify, $icingaweb2::config::tls['noverify']),
    cipher      => icingaweb2::pick($icingaweb2::module::icingadb::db_tls_cipher, $icingaweb2::config::tls['cipher']),
  }
  $settings          = $icingaweb2::module::icingadb::settings
  $commandtransports = $icingaweb2::module::icingadb::commandtransports

  icingaweb2::resource::database { 'icingaweb2-module-icingadb':
    type         => $db_type,
    host         => $db_host,
    port         => $db_port,
    database     => $db_name,
    username     => $db_username,
    password     => $db_password,
    charset      => $db_charset,
    use_tls      => $db_use_tls,
    tls_noverify => icingaweb2::pick($db_tls['noverify'], $icingaweb2::config::tls['noverify']),
    tls_key      => $db_tls['key_file'],
    tls_cert     => $db_tls['cert_file'],
    tls_cacert   => icingaweb2::pick($db_tls['cacert_file'], $icingaweb2::config::tls['cacert_file']),
    tls_capath   => icingaweb2::pick($db_tls['capath'], $icingaweb2::config::tls['capath']),
    tls_cipher   => icingaweb2::pick($db_tls['cipher'], $icingaweb2::config::tls['cipher']),
  }

  create_resources('icingaweb2::inisection', $settings)
  create_resources('icingaweb2::module::icingadb::commandtransport', $commandtransports)
}
