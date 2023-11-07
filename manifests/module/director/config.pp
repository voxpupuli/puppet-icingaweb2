# @summary
#   Configure the director module.
#
# @api private
#
class icingaweb2::module::director::config {
  assert_private()

  $stdlib_version = $icingaweb2::globals::stdlib_version
  $icingacli_bin  = $icingaweb2::globals::icingacli_bin
  $install_method = $icingaweb2::module::director::install_method
  $db             = $icingaweb2::module::director::db
  $import_schema  = $icingaweb2::module::director::import_schema
  $kickstart      = $icingaweb2::module::director::kickstart
  $use_tls        = $icingaweb2::module::director::use_tls
  $tls            = $icingaweb2::module::director::tls + {
    cacert_file => icingaweb2::pick($icingaweb2::module::director::tls['cacert_file'], $icingaweb2::config::tls['cacert_file']),
    capath      => icingaweb2::pick($icingaweb2::module::director::tls_capath, $icingaweb2::config::tls['capath']),
    noverify    => icingaweb2::pick($icingaweb2::module::director::tls_noverify, $icingaweb2::config::tls['noverify']),
    cipher      => icingaweb2::pick($icingaweb2::module::director::tls_cipher, $icingaweb2::config::tls['cipher']),
  }
  $settings       = $icingaweb2::module::director::db_settings + $icingaweb2::module::director::kickstart_settings
  $service_user   = $icingaweb2::module::director::service_user

  Exec {
    user     => 'root',
    path     => $facts['path'],
    provider => 'shell',
  }

  icingaweb2::resource::database { 'icingaweb2-module-director':
    type         => $db['type'],
    host         => $db['host'],
    port         => $db['port'],
    database     => $db['database'],
    username     => $db['username'],
    password     => $db['password'],
    charset      => pick($icingaweb2::module::director::db_charset, $icingaweb2::globals::db_charset[$db['type']]['director']),
    use_tls      => $use_tls,
    tls_noverify => $tls['noverify'],
    tls_key      => $tls['key_file'],
    tls_cert     => $tls['cert_file'],
    tls_cacert   => $tls['cacert_file'],
    tls_capath   => $tls['capath'],
    tls_cipher   => $tls['cipher'],
  }

  create_resources('icingaweb2::inisection', $settings)

  if $install_method == 'git' {
    systemd::unit_file { 'icinga-director.service':
      content => epp('icingaweb2/icinga-director.service.epp', {
          'conf_user'     => $service_user,
          'icingacli_bin' => $icingacli_bin,
      }),
    }
  }

  if $import_schema {
    exec { 'director-migration':
      command => "${icingacli_bin} director migration run",
      onlyif  => "${icingacli_bin} director migration pending",
    }

    if $kickstart {
      exec { 'director-kickstart':
        command => "${icingacli_bin} director kickstart run",
        onlyif  => "${icingacli_bin} director kickstart required",
        require => Exec['director-migration'],
      }
    }
  }
}
