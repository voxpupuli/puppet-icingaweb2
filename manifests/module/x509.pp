# @summary Installs the x509 module
#
# @param ensure
#   Ensures the state of the x509 module.
#
# @param module_dir
#   Target directory of the module.
#
# @param git_repository
#   The upstream module repository.
#
# @param git_revision
#   The version of the module that needs to be used.
#
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param db_type
#   The database type. Either mysql or pgsql.
#
# @param db_resource_name
#   Name for the x509 database resource.
#
# @param db_host
#   The host where the database will be running
#
# @param db_port
#   The port on which the database is accessible.
#
# @param db_name
#   The name of the database this module should use.
#
# @param db_username
#   The username needed to access the database.
#
# @param db_password
#   The password needed to access the database.
#
# @param db_charset
#   The charset the database is set to.
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
# @param import_schema
#   Whether to import the database schema or not. Options `mariadb` and `mysql`,
#   both means true. With mariadb its cli options are used for the import,
#   whereas with mysql its different options.
#
# @param manage_service
#   If set to true the service (daemon) is managed.
#
# @param service_ensure
#   Wether the service is `running` or `stopped`.
#
# @param service_enable
#   Whether the service should be started at boot time.
#
# @param service_user
#   The user as which the service is running. Only valid if `install_method` is set to `git`.
#
# @example
#   class { 'icingaweb2::module::x509':
#     ensure       => present,
#     git_revision => 'v1.2.1',
#     db_host      => 'localhost',
#     db_name      => 'x509',
#     db_username  => 'x509',
#     db_password  => Sensitive('supersecret'),
#   }
#
class icingaweb2::module::x509 (
  Enum['absent', 'present']                  $ensure,
  Enum['git', 'none', 'package']             $install_method,
  Stdlib::HTTPUrl                            $git_repository,
  String[1]                                  $package_name,
  Boolean                                    $manage_service,
  Stdlib::Ensure::Service                    $service_ensure,
  Boolean                                    $service_enable,
  String[1]                                  $service_user,
  Enum['mysql', 'pgsql']                     $db_type,
  String[1]                                  $db_resource_name,
  Stdlib::Host                               $db_host,
  String[1]                                  $db_name,
  String[1]                                  $db_username,
  Optional[Icingaweb2::Secret]               $db_password     = undef,
  Optional[Stdlib::Port]                     $db_port         = undef,
  Optional[String[1]]                        $db_charset      = undef,
  Optional[Icingaweb2::ImportSchema]         $import_schema   = undef,
  Stdlib::Absolutepath                       $module_dir      = "${icingaweb2::globals::default_module_path}/x509",
  Optional[String[1]]                        $git_revision    = undef,
  Optional[Boolean]                          $use_tls         = undef,
  Optional[Stdlib::Absolutepath]             $tls_key_file    = undef,
  Optional[Stdlib::Absolutepath]             $tls_cert_file   = undef,
  Optional[Stdlib::Absolutepath]             $tls_cacert_file = undef,
  Optional[Stdlib::Absolutepath]             $tls_capath      = undef,
  Optional[Icingaweb2::Secret]               $tls_key         = undef,
  Optional[String[1]]                        $tls_cert        = undef,
  Optional[String[1]]                        $tls_cacert      = undef,
  Optional[Boolean]                          $tls_noverify    = undef,
  Optional[String[1]]                        $tls_cipher      = undef,
) {
  require icingaweb2

  $module_conf_dir = "${icingaweb2::globals::conf_dir}/modules/x509"
  $cert_dir        = "${icingaweb2::globals::state_dir}/x509/certs"

  $db = {
    type     => $db_type,
    database => $db_name,
    host     => $db_host,
    port     => $db_port,
    username => $db_username,
    password => $db_password,
  }

  $tls = icinga::cert::files(
    $db_username,
    $cert_dir,
    $tls_key_file,
    $tls_cert_file,
    $tls_cacert_file,
    $tls_key,
    $tls_cert,
    $tls_cacert,
  )

  $settings = {
    'icingaweb2-module-x509-backend' => {
      'section_name' => 'backend',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => {
        'resource' => $db_resource_name,
      },
    },
  }

  class { 'icingaweb2::module::x509::install': }
  -> class { 'icingaweb2::module::x509::config': }
  ~> class { 'icingaweb2::module::x509::service': }
  contain icingaweb2::module::x509::install
  contain icingaweb2::module::x509::config
  contain icingaweb2::module::x509::service
}
