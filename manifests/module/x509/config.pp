# @summary
#   Configure the x509 module
#
# @api private
#
class icingaweb2::module::x509::config {
  assert_private()

  $icingacli_bin  = $icingaweb2::globals::icingacli_bin
  $install_method = $icingaweb2::module::x509::install_method
  $db             = $icingaweb2::module::x509::db
  $db_resource    = $icingaweb2::module::x509::db_resource_name
  $import_schema  = $icingaweb2::module::x509::import_schema
  $use_tls        = $icingaweb2::module::x509::use_tls
  $tls            = $icingaweb2::module::x509::tls + {
    cacert_file => icingaweb2::pick($icingaweb2::module::x509::tls['cacert_file'], $icingaweb2::config::tls['cacert_file']),
    capath      => icingaweb2::pick($icingaweb2::module::x509::tls_capath, $icingaweb2::config::tls['capath']),
    noverify    => icingaweb2::pick($icingaweb2::module::x509::tls_noverify, $icingaweb2::config::tls['noverify']),
    cipher      => icingaweb2::pick($icingaweb2::module::x509::tls_cipher, $icingaweb2::config::tls['cipher']),
  }
  $mysql_schema   = "${icingaweb2::module::x509::module_dir}${icingaweb2::globals::mysql_x509_schema}"
  $pgsql_schema   = "${icingaweb2::module::x509::module_dir}${icingaweb2::globals::pgsql_x509_schema}"
  $service_user   = $icingaweb2::module::x509::service_user
  $settings       = $icingaweb2::module::x509::settings

  Exec {
    user     => 'root',
    path     => $facts['path'],
    provider => 'shell',
  }

  if $install_method == 'git' {
    systemd::unit_file { 'icinga-x509.service':
      ensure  => 'present',
      content => epp('icingaweb2/icinga-x509.service.epp', {
          'conf_user'     => $service_user,
          'icingacli_bin' => $icingacli_bin,
      }),
    }
  }

  if $install_method == 'package' {
    systemd::dropin_file { 'icinga-x509.conf':
      unit    => 'icinga-x509.service',
      content => "[Service]\nUser=${service_user}",
    }
  }

  icingaweb2::resource::database { $db_resource:
    type         => $db['type'],
    host         => $db['host'],
    port         => $db['port'],
    database     => $db['database'],
    username     => $db['username'],
    password     => $db['password'],
    charset      => pick($icingaweb2::module::x509::db_charset, $icingaweb2::globals::db_charset[$db['type']]['x509']),
    use_tls      => $use_tls,
    tls_noverify => $tls['noverify'],
    tls_key      => $tls['key_file'],
    tls_cert     => $tls['cert_file'],
    tls_cacert   => $tls['cacert_file'],
    tls_capath   => $tls['capath'],
    tls_cipher   => $tls['cipher'],
  }

  create_resources('icingaweb2::inisection', $settings)

  if $import_schema {
    $real_db_type = if $import_schema =~ Boolean {
      if $db['type'] == 'pgsql' { 'pgsql' } else { 'mariadb' }
    } else {
      $import_schema
    }
    $db_cli_options = icinga::db::connect($db + { type => $real_db_type }, $tls, $use_tls)

    case $db['type'] {
      'mysql': {
        exec { 'import icingaweb2::module::x509 schema':
          command => "mysql ${db_cli_options} < '${mysql_schema}'",
          unless  => "mysql ${db_cli_options} -Ns -e 'SELECT * FROM x509_certificate'",
        }
      }
      'pgsql': {
        $_db_password = icingaweb2::unwrap($db['password'])
        exec { 'import icingaweb2::module::x509 schema':
          environment => ["PGPASSWORD=${_db_password}"],
          command     => "psql '${db_cli_options}' -w -f ${pgsql_schema}",
          unless      => "psql '${db_cli_options}' -w -c 'SELECT * FROM x509_certificate'",
        }
      } # pgsql (not supported)
      default: {
        fail('The database type you provided is not supported.')
      }
    }
  } # schema import
}
