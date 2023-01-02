# @summary
#   Manages the icingadb module. This module is mandatory for probably every setup.
#
# @note At first have a look at the [Monitoring module documentation](https://www.icinga.com/docs/icingaweb2/latest/modules/monitoring/doc/01-About/).
#
# @param ensure
#   Enable or disable module.
#
# @param protected_customvars
#   Custom variables in Icinga 2 may contain sensible information. Set patterns for custom variables
#   that should be hidden in the web interface.
#
# @param icingadb_type
#   Type of your IDO database. Either `mysql` or `pgsql`.
#
# @param icingadb_host
#   Hostname of the IDO database.
#
# @param icingadb_port
#   Port of the IDO database.
#
# @param icingadb_db_name
#   Name of the IDO database.
#
# @param icingadb_db_username
#   Username for IDO DB connection.
#
# @param icingadb_db_password
#   Password for IDO DB connection.
#
# @param icingadb_db_charset
#   The character set to use for the database connection.
#
# @param use_tls
#   Either enable or disable TLS encryption to the database. Other TLS parameters
#   are only affected if this is set to 'true'.
#
# @param tls_key_file
#   Location of the private key for client authentication. Only valid if tls is enabled.
#
# @param tls_cert_file
#   Location of the certificate for client authentication. Only valid if tls is enabled.
#
# @param tls_cacert_file
#   Location of the ca certificate. Only valid if tls is enabled.
#
# @param tls_key
#   The private key to store in spicified `tls_key_file` file. Only valid if tls is enabled.
#
# @param tls_cert
#   The certificate to store in spicified `tls_cert_file` file. Only valid if tls is enabled.
#
# @param tls_cacert
#   The ca certificate to store in spicified `tls_cacert_file` file. Only valid if tls is enabled.
#
# @param tls_capath
#   The file path to the directory that contains the trusted SSL CA certificates, which are stored in PEM format.
#   Only available for the mysql database.
#
# @param tls_noverify
#   Disable validation of the server certificate.
#
# @param tls_cipher
#   Cipher to use for the encrypted database connection.
#
# @param commandtransports
#   A hash of command transports.
#
# @example This module is mandatory for almost every setup. It connects your Icinga Web interface to the Icinga 2 core. Current and history information are queried through the IDO database. Actions such as `Check Now`, `Set Downtime` or `Acknowledge` are send to the Icinga 2 API.
#
# Requirements:
#   * IDO feature in Icinga 2 (MySQL or PostgreSQL)
#   * `ApiUser` object in Icinga 2 with proper permissions
#
#   class {'icingaweb2::module::icingadb':
#     icingadb_host        => 'localhost',
#     icingadb_type        => 'mysql',
#     icingadb_db_name     => 'icingadb',
#     icingadb_db_username => 'icingadb',
#     icingadb_db_password => 'supersecret',
#     commandtransports => {
#       icinga2 => {
#         transport => 'api',
#         username  => 'icingaweb2',
#         password  => 'supersecret',
#       }
#     }
#   }
#
class icingaweb2::module::icingadb(
  Enum['absent', 'present']      $ensure               = 'present',
  Variant[String, Array[String]] $protected_customvars = ['*pw*', '*pass*', 'community'],
  Enum['mysql', 'pgsql']         $icingadb_type             = 'mysql',
  Optional[Stdlib::Host]         $icingadb_host             = undef,
  Optional[Stdlib::Port]         $icingadb_port             = undef,
  Optional[String]               $icingadb_db_name          = undef,
  Optional[String]               $icingadb_db_username      = undef,
  Optional[Icingaweb2::Secret]   $icingadb_db_password      = undef,
  Optional[Icingaweb2::Secret]   $icingadb_redis_password   = undef,
  Optional[String]               $icingadb_db_charset       = undef,
  Optional[Boolean]              $use_tls              = undef,
  Optional[Stdlib::Absolutepath] $tls_key_file         = undef,
  Optional[Stdlib::Absolutepath] $tls_cert_file        = undef,
  Optional[Stdlib::Absolutepath] $tls_cacert_file      = undef,
  Optional[Stdlib::Absolutepath] $tls_capath           = undef,
  Optional[Icingaweb2::Secret]   $tls_key              = undef,
  Optional[String]               $tls_cert             = undef,
  Optional[String]               $tls_cacert           = undef,
  Optional[Boolean]              $tls_noverify         = undef,
  Optional[String]               $tls_cipher           = undef,
  Hash                           $commandtransports    = {},

) {

  $conf_dir        = $::icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/icingadb"

  case $::osfamily {
    'Debian': {
      $install_method = 'package'
      $package_name   = 'icingadb-web'
    }
    default: {
      $install_method = 'none'
      $package_name   = undef
    }
  }

  $tls = merge(delete($::icingaweb2::config::tls, ['key', 'cert', 'cacert']), delete_undef_values(merge(icingaweb2::cert::files(
    'client',
    $module_conf_dir,
    $tls_key_file,
    $tls_cert_file,
    $tls_cacert_file,
    $tls_key,
    $tls_cert,
    $tls_cacert,
  ), {
    capath   => $tls_capath,
    noverify => $tls_noverify,
    cipher   => $tls_cipher,
  })))

  icingaweb2::tls::client { 'icingaweb2::module::monitoring tls client config':
    args => $tls,
  }

  icingaweb2::resource::database { 'icingaweb2-module-icingadb':
    type         => $icingadb_type,
    host         => $icingadb_host,
    port         => pick($icingadb_port, $::icingaweb2::globals::port[$icingadb_type]),
    database     => $icingadb_db_name,
    username     => $icingadb_db_username,
    password     => $icingadb_db_password,
    charset      => $icingadb_db_charset,
    use_tls      => $use_tls,
    tls_noverify => $tls['noverify'],
    tls_key      => $tls['key_file'],
    tls_cert     => $tls['cert_file'],
    tls_cacert   => $tls['cacert_file'],
    tls_capath   => $tls['capath'],
    tls_cipher   => $tls['cipher'],
  }

  $database_settings = {
    'resource' => 'icingaweb2-module-icingadb',
  }

  $redis_settings = {
    'host'     => $icingadb_host,
    'password' => $icingadb_redis_password, 
  }

  $settings = {
    'module-icingadb-database' => {
      'section_name' => 'icingadb',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($database_settings)
    },
    'module-icingadb-redis' => {
      'section_name' => 'redis1',
      'target'       => "${module_conf_dir}/redis.ini",
      'settings'     => delete_undef_values($redis_settings)
    }

  }

  create_resources('icingaweb2::module::icingadb::commandtransport', $commandtransports)

  icingaweb2::module { 'icingadb':
    ensure         => $ensure,
    install_method => $install_method,
    package_name   => $package_name,
    settings       => $settings,
  }

}
