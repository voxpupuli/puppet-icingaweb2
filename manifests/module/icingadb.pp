# @summary
#   Manages the icingadb module. This module is still optional at the moment.
#
# @note At first have a look at the [IcingaDB module documentation](https://icinga.com/docs/icinga-db/latest/doc/01-About/).
#
# @param ensure
#   Enable or disable module.
#
# @param package_name
#   IicngaDB-Web module package name.
#
# @param db_type
#   Type of your IDO database. Either `mysql` or `pgsql`.
#
# @param db_host
#   Hostname of the IcingaDB database.
#
# @param db_port
#   Port of the IcingaDB database.
#
# @param db_name
#   Name of the IcingaDB database.
#
# @param db_username
#   Username for IcingaDB database connection.
#
# @param db_password
#   Password for IcingaDB database connection.
#
# @param db_charset
#   The character set to use for the IcingaDB database connection.
#
# @param db_use_tls
#   Either enable or disable TLS encryption to the database. Other TLS parameters
#   are only affected if this is set to 'true'.
#
# @param db_tls_cert_file
#   Location of the certificate for client authentication. Only valid if db_use_tls is enabled.
#
# @param db_tls_key_file
#   Location of the private key for client authentication. Only valid if db_use_tls is enabled.
#
# @param db_tls_cacert_file
#   Location of the CA root certificate. Only valid if db_use_tls is enabled.
#
# @param db_tls_cert
#   The client certificate in PEM format. Only valid if db_use_tls is enabled.
#
# @param db_tls_key
#   The client private key in PEM format. Only valid if db_use_tls is enabled.
#
# @param db_tls_cacert
#   The CA root certificate in PEM format. Only valid if db_use_tls is enabled.
#
# @param db_tls_capath
#   The file path to the directory that contains the trusted SSL CA certificates, which are stored in PEM format.
#   Only available for the mysql database.
#
# @param db_tls_noverify
#   Disable validation of the server certificate.
#
# @param db_tls_cipher
#   Cipher to use for the encrypted database connection.
#
# @param redis_host
#   Redis host to connect.
#
# @param redis_port
#   Connect `redis_host` om this port.
#
# @param redis_password
#   Password for Redis connection.
#
# @param redis_primary_host
#   Alternative parameter to use for `redis_host`. Useful for high availability environments.
#
# @param redis_primary_port
#   Alternative parameter to use for `redis_port`. Useful for high availability environments.
#
# @param redis_primary_password
#   Alternative parameter to use for `redis_passwod`. Useful for high availability environments.
#
# @param redis_secondary_host
#   Fallback Redis host to connect if the first one fails.
#
# @param redis_secondary_port
#   Port to connect on the fallback Redis server.
#
# @param redis_secondary_password
#   Password for the second Redis server.
#
# @param redis_use_tls
#   Use tls encrypt connection for Redis.
#   All Credentials are applied for both connections in a high availability environments.
#
# @param redis_tls_cert
#   Client certificate in PEM format to authenticate to Redis.
#   Only valid if redis_use_tls is enabled.
#
# @param redis_tls_key
#   Client private key in PEM format. Only valid if redis_use_tls is enabled.
#
# @param redis_tls_cacert
#   The CA certificate in PEM format. Only valid if redis_use_tls is enabled.
#
# @param redis_tls_cert_file
#   Location of the client certificate. Only valid if redis_use_tls is enabled.
#
# @param redis_tls_key_file
#   Location of the private key. Only valid if redis_use_tls is enabled.
#
# @param redis_tls_cacert_file
#   Location of the CA certificate. Only valid if redis_use_tls is enabled.
#
# @param commandtransports
#   A hash of command transports.
#
class icingaweb2::module::icingadb (
  String                          $package_name,
  Icingaweb2::Secret              $db_password,
  Enum['absent', 'present']       $ensure                   = 'present',
  Enum['mysql', 'pgsql']          $db_type                  = 'mysql',
  Stdlib::Host                    $db_host                  = 'localhost',
  Optional[Stdlib::Port]          $db_port                  = undef,
  String                          $db_name                  = 'icingadb',
  String                          $db_username              = 'icingadb',
  Optional[String]                $db_charset               = undef,
  Optional[Boolean]               $db_use_tls               = undef,
  Optional[String]                $db_tls_cert              = undef,
  Optional[Icingaweb2::Secret]    $db_tls_key               = undef,
  Optional[String]                $db_tls_cacert            = undef,
  Optional[Stdlib::Absolutepath]  $db_tls_cert_file         = undef,
  Optional[Stdlib::Absolutepath]  $db_tls_key_file          = undef,
  Optional[Stdlib::Absolutepath]  $db_tls_cacert_file       = undef,
  Optional[Stdlib::Absolutepath]  $db_tls_capath            = undef,
  Optional[Boolean]               $db_tls_noverify          = undef,
  Optional[String]                $db_tls_cipher            = undef,
  Stdlib::Host                    $redis_host               = 'localhost',
  Optional[Stdlib::Port]          $redis_port               = undef,
  Optional[Icingaweb2::Secret]    $redis_password           = undef,
  Stdlib::Host                    $redis_primary_host       = $redis_host,
  Optional[Stdlib::Port]          $redis_primary_port       = $redis_port,
  Optional[Icingaweb2::Secret]    $redis_primary_password   = $redis_password,
  Optional[Stdlib::Host]          $redis_secondary_host     = undef,
  Optional[Stdlib::Port]          $redis_secondary_port     = undef,
  Optional[Icingaweb2::Secret]    $redis_secondary_password = undef,
  Optional[Boolean]               $redis_use_tls            = undef,
  Optional[String]                $redis_tls_cert           = undef,
  Optional[Icingaweb2::Secret]    $redis_tls_key            = undef,
  Optional[String]                $redis_tls_cacert         = undef,
  Optional[Stdlib::Absolutepath]  $redis_tls_cert_file      = undef,
  Optional[Stdlib::Absolutepath]  $redis_tls_key_file       = undef,
  Optional[Stdlib::Absolutepath]  $redis_tls_cacert_file    = undef,
  Hash[String, Hash]              $commandtransports        = {},
) {
  $conf_dir        = $icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/icingadb"

  if $redis_use_tls {
    $redis_tls_files = icingaweb2::cert::files(
      'redis',
      $module_conf_dir,
      $redis_tls_key_file,
      $redis_tls_cert_file,
      $redis_tls_cacert_file,
      $redis_tls_key,
      $redis_tls_cert,
      $redis_tls_cacert,
    )
    $redis_settings = delete_undef_values({
        tls  => true,
        cert => $redis_tls_files['cert_file'],
        key  => $redis_tls_files['key_file'],
        ca   => $redis_tls_files['cacert_file'],
    })
    icingaweb2::tls::client { 'icingaweb2::module::icingadb redis client tls config':
      args  => $redis_tls_files,
    }
  } else {
    $redis_settings = {}
  }

  $settings = {
    'icingaweb2-module-icingadb-config' => {
      'section_name' => 'icingadb',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => {
        resource => 'icingaweb2-module-icingadb',
      },
    },
    'icingaweb2-module-icingadb-redis' => {
      'section_name' => 'redis',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => $redis_settings,
    },
    'icingaweb2-module-icingadb-redis1' => {
      'section_name' => 'redis1',
      'target'       => "${module_conf_dir}/redis.ini",
      'settings'     => delete_undef_values({
          host     => $redis_primary_host,
          port     => $redis_primary_port,
          password => $redis_primary_password,
      }),
    },
    'icingaweb2-module-icingadb-redis2' => {
      'section_name' => 'redis2',
      'target'       => "${module_conf_dir}/redis.ini",
      'settings'     => delete_undef_values({
          host     => $redis_secondary_host,
          port     => $redis_secondary_port,
          password => $redis_secondary_password,
      }),
    },
  }

  $db_tls = merge(delete($icingaweb2::config::tls, ['key', 'cert', 'cacert']), delete_undef_values(merge(icingaweb2::cert::files(
          'client',
          $module_conf_dir,
          $db_tls_key_file,
          $db_tls_cert_file,
          $db_tls_cacert_file,
          $db_tls_key,
          $db_tls_cert,
          $db_tls_cacert,
        ), {
          capath   => $db_tls_capath,
          noverify => $db_tls_noverify,
          cipher   => $db_tls_cipher,
  })))

  icingaweb2::tls::client { 'icingaweb2::module::icingadb tls client config':
    args => $db_tls,
  }

  icingaweb2::resource::database { 'icingaweb2-module-icingadb':
    type         => $db_type,
    host         => $db_host,
    port         => pick($db_port, $icingaweb2::globals::port[$db_type]),
    database     => $db_name,
    username     => $db_username,
    password     => $db_password,
    charset      => $db_charset,
    use_tls      => $db_use_tls,
    tls_noverify => $db_tls['noverify'],
    tls_key      => $db_tls['key_file'],
    tls_cert     => $db_tls['cert_file'],
    tls_cacert   => $db_tls['cacert_file'],
    tls_capath   => $db_tls['capath'],
    tls_cipher   => $db_tls['cipher'],
  }

  create_resources('icingaweb2::module::icingadb::commandtransport', $commandtransports)

  icingaweb2::module { 'icingadb':
    ensure         => $ensure,
    install_method => 'package',
    package_name   => $package_name,
    settings       => $settings,
  }
}
