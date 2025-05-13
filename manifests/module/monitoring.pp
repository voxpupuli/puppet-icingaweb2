# @summary
#   Manages the monitoring module. This module is deprecated.
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
# @param ido_type
#   Type of your IDO database. Either `mysql` or `pgsql`.
#
# @param ido_host
#   Hostname of the IDO database.
#
# @param ido_port
#   Port of the IDO database.
#
# @param ido_resource_name
#   Resource name for the IDO database.
#
# @param ido_db_name
#   Name of the IDO database.
#
# @param ido_db_username
#   Username for IDO DB connection.
#
# @param ido_db_password
#   Password for IDO DB connection.
#
# @param ido_db_charset
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
# @param settings
#   General configuration of module monitoring.
#   See official Icinga [documentation](https://icinga.com/docs/icinga-web/latest/modules/monitoring/doc/03-Configuration)
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
#   class {'icingaweb2::module::monitoring':
#     ido_host        => 'localhost',
#     ido_type        => 'mysql',
#     ido_db_name     => 'icinga2',
#     ido_db_username => 'icinga2',
#     ido_db_password => 'supersecret',
#     commandtransports => {
#       icinga2 => {
#         transport => 'api',
#         username  => 'icingaweb2',
#         password  => 'supersecret',
#       }
#     }
#   }
#
class icingaweb2::module::monitoring (
  Enum['mysql', 'pgsql']               $ido_type,
  Enum['absent', 'present']            $ensure               = 'present',
  Variant[String[1], Array[String[1]]] $protected_customvars = ['*pw*', '*pass*', 'community'],
  Hash                                 $commandtransports    = {},
  Hash[String[1], Any]                 $settings             = {},
  Stdlib::Host                         $ido_host             = 'localhost',
  String                               $ido_resource_name    = 'icinga2',
  String                               $ido_db_name          = 'icinga2',
  String                               $ido_db_username      = 'icinga2',
  Optional[Stdlib::Port]               $ido_port             = undef,
  Optional[Icinga::Secret]             $ido_db_password      = undef,
  Optional[String[1]]                  $ido_db_charset       = undef,
  Optional[Boolean]                    $use_tls              = undef,
  Optional[Stdlib::Absolutepath]       $tls_key_file         = undef,
  Optional[Stdlib::Absolutepath]       $tls_cert_file        = undef,
  Optional[Stdlib::Absolutepath]       $tls_cacert_file      = undef,
  Optional[Stdlib::Absolutepath]       $tls_capath           = undef,
  Optional[Icinga::Secret]             $tls_key              = undef,
  Optional[String[1]]                  $tls_cert             = undef,
  Optional[String[1]]                  $tls_cacert           = undef,
  Optional[Boolean]                    $tls_noverify         = undef,
  Optional[String[1]]                  $tls_cipher           = undef,
) {
  require icingaweb2

  $module_conf_dir = "${icingaweb2::globals::conf_dir}/modules/monitoring"
  $cert_dir        = "${icingaweb2::globals::state_dir}/monitoring/certs"

  $db = {
    type     => $ido_type,
    database => $ido_db_name,
    host     => $ido_host,
    port     => $ido_port,
    username => $ido_db_username,
    password => $ido_db_password,
  }

  $tls = icinga::cert::files(
    $ido_db_username,
    $cert_dir,
    $tls_key_file,
    $tls_cert_file,
    $tls_cacert_file,
    $tls_key,
    $tls_cert,
    $tls_cacert,
  )

  $backend_settings = {
    'type'     => 'ido',
    'resource' => $ido_resource_name,
  }

  $security_settings = {
    'protected_customvars' => $protected_customvars ? {
      String        => $protected_customvars,
      Array[String] => join($protected_customvars, ','),
    },
  }

  $_settings = {
    'module-monitoring-backends' => {
      'section_name' => 'backends',
      'target'       => "${module_conf_dir}/backends.ini",
      'settings'     => delete_undef_values($backend_settings),
    },
    'module-monitoring-security' => {
      'section_name' => 'security',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($security_settings),
    },
    'module-monitoring-general' => {
      'section_name' => 'settings',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($settings),
    },
  }

  class { 'icingaweb2::module::monitoring::install': }
  -> class { 'icingaweb2::module::monitoring::config': }
  contain icingaweb2::module::monitoring::install
  contain icingaweb2::module::monitoring::config
}
