# @summary
#   Configure the VSphereDB module
#
# @api private
#
class icingaweb2::module::vspheredb::config {
  assert_private()

  $module_conf_dir        = "${icingaweb2::globals::conf_dir}/modules/vspheredb"
  $conf_group             = $icingaweb2::conf_group
  $mysql_vspheredb_schema = "${icingaweb2::module::vspheredb::module_dir}${icingaweb2::globals::mysql_vspheredb_schema}"
  $pgsql_vspheredb_schema = "${icingaweb2::module::vspheredb::module_dir}${icingaweb2::globals::pgsql_vspheredb_schema}"
  $db                     = $icingaweb2::module::vspheredb::db
  $import_schema          = $icingaweb2::module::vspheredb::import_schema
  $use_tls                = $icingaweb2::module::vspheredb::use_tls
  $tls                    = $icingaweb2::module::vspheredb::tls + {
    cacert_file => icingaweb2::pick($icingaweb2::module::vspheredb::tls['cacert_file'], $icingaweb2::config::tls['cacert_file']),
    capath      => icingaweb2::pick($icingaweb2::module::vspheredb::tls_capath, $icingaweb2::config::tls['capath']),
    noverify    => icingaweb2::pick($icingaweb2::module::vspheredb::tls_noverify, $icingaweb2::config::tls['noverify']),
    cipher      => icingaweb2::pick($icingaweb2::module::vspheredb::tls_cipher, $icingaweb2::config::tls['cipher']),
  }
  $icingacli_bin          = $icingaweb2::globals::icingacli_bin
  $service_user           = $icingaweb2::module::vspheredb::service_user
  $install_method         = $icingaweb2::module::vspheredb::install_method

  Exec {
    user     => 'root',
    path     => $facts['path'],
    provider => 'shell',
  }

  if $install_method == 'git' {
    systemd::tmpfile { 'icinga-vspheredb.conf':
      content => "d /run/icinga-vspheredb 0755 ${service_user} ${conf_group} -",
    }
    systemd::unit_file { 'icinga-vspheredb.service':
      ensure  => 'present',
      content => epp('icingaweb2/icinga-vspheredb.service.epp', {
          'conf_user'     => $service_user,
          'icingacli_bin' => $icingacli_bin,
      }),
    }
  }

  icingaweb2::resource::database { 'icingaweb2-module-vspheredb':
    type         => $db['type'],
    host         => $db['host'],
    port         => $db['port'],
    database     => $db['database'],
    username     => $db['username'],
    password     => $db['password'],
    charset      => pick($icingaweb2::module::vspheredb::db_charset, $icingaweb2::globals::db_charset[$db['type']]['vspheredb']),
    use_tls      => $use_tls,
    tls_noverify => $tls['noverify'],
    tls_key      => $tls['key_file'],
    tls_cert     => $tls['cert_file'],
    tls_cacert   => $tls['cacert_file'],
    tls_capath   => $tls['capath'],
    tls_cipher   => $tls['cipher'],
  }

  if $import_schema {
    $real_db_type = if $import_schema =~ Boolean {
      if $db['type'] == 'pgsql' { 'pgsql' } else { 'mariadb' }
    } else {
      $import_schema
    }
    $db_cli_options = icinga::db::connect($db + { type => $real_db_type }, $tls, $use_tls)

    case $db['type'] {
      'mysql': {
        exec { 'import icingaweb2::module::vspheredb schema':
          command => "mysql ${db_cli_options} < '${mysql_vspheredb_schema}'",
          unless  => "mysql ${db_cli_options} -Ns -e 'SELECT schema_version FROM vspheredb_schema_migration'",
        }
      }
      'pgsql': {
        $_db_password = icingaweb2::unwrap($db['password'])
        exec { 'import icingaweb2::module::vspheredb schema':
          environment => ["PGPASSWORD=${_db_password}"],
          command     => "psql '${db_cli_options}' -w -f ${pgsql_vspheredb_schema}",
          unless      => "psql '${db_cli_options}' -w -c 'SELECT schema_version FROM vspheredb_schema_migration'",
        }
      } # pgsql (not supported)
      default: {
        fail('The database type you provided is not supported.')
      }
    }
  } # schema import
}
