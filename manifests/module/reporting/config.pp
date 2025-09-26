# @summary
#   Configure the reporting module.
#
# @api private
#
class icingaweb2::module::reporting::config {
  assert_private()

  $module_conf_dir = "${icingaweb2::globals::conf_dir}/modules/reporting"
  $conf_group      = $icingaweb2::conf_group
  $mysql_schema    = "${icingaweb2::module::reporting::module_dir}${icingaweb2::globals::mysql_reporting_schema}"
  $pgsql_schema    = "${icingaweb2::module::reporting::module_dir}${icingaweb2::globals::pgsql_reporting_schema}"
  $db              = $icingaweb2::module::reporting::db
  $db_resource     = $icingaweb2::module::reporting::db_resource_name
  $import_schema   = $icingaweb2::module::reporting::import_schema
  $use_tls         = $icingaweb2::module::reporting::use_tls
  $tls             = $icingaweb2::module::reporting::tls + {
    cacert_file => icingaweb2::pick($icingaweb2::module::reporting::tls['cacert_file'], $icingaweb2::config::tls['cacert_file']),
    capath      => icingaweb2::pick($icingaweb2::module::reporting::tls_capath, $icingaweb2::config::tls['capath']),
    noverify    => icingaweb2::pick($icingaweb2::module::reporting::tls_noverify, $icingaweb2::config::tls['noverify']),
    cipher      => icingaweb2::pick($icingaweb2::module::reporting::tls_cipher, $icingaweb2::config::tls['cipher']),
  }
  $icingacli_bin   = $icingaweb2::globals::icingacli_bin
  $service_user    = $icingaweb2::module::reporting::service_user
  $install_method  = $icingaweb2::module::reporting::install_method
  $settings        = $icingaweb2::module::reporting::settings

  Exec {
    user     => 'root',
    path     => $facts['path'],
    provider => 'shell',
  }

  if $install_method == 'git' {
    systemd::unit_file { 'icinga-reporting.service':
      ensure  => 'present',
      content => epp('icingaweb2/icinga-reporting.service.epp', {
        'conf_user'     => $service_user,
        'icingacli_bin' => $icingaweb2::globals::icingacli_bin,
      }),
    }
  }

  if $install_method == 'package' {
    systemd::dropin_file { 'icinga-reporting.conf':
      unit    => 'icinga-reporting.service',
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
    charset      => pick($icingaweb2::module::reporting::db_charset, $icingaweb2::globals::db_charset[$db['type']]['reporting']),
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
        exec { 'import icingaweb2::module::reporting schema':
          command => "mysql ${db_cli_options} < '${mysql_schema}'",
          unless  => "mysql ${db_cli_options} -Ns -e 'SELECT * FROM report'",
        }
      }
      'pgsql': {
        $_db_password = unwrap($db['password'])
        exec { 'import icingaweb2::module::reporting schema':
          environment => ["PGPASSWORD=${_db_password}"],
          command     => "psql '${db_cli_options}' -w -f ${pgsql_schema}",
          unless      => "psql '${db_cli_options}' -w -c 'SELECT * FROM report'",
        }
      } # pgsql (not supported)
      default: {
        fail('The database type you provided is not supported.')
      }
    }
  } # schema import
}
