# @summary Installs the vsphereDB plugin
#
# @param ensure
#   Ensur es the state of the vspheredb module.
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
#   The database type. Either mysql or postgres.
#
# @param db_resource_name
#   Name for the vspheredb database resource.
#
# @param db_host
#   The host where the vspheredb-database will be running
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
#   Whether to import the database schema or not. New options `mariadb` and `mysql`,
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
#   class { 'icingaweb2::module::vspheredb':
#     ensure       => 'present',
#     git_revision => 'v1.1.0',
#     db_host      => 'localhost',
#     db_name      => 'vspheredb',
#     db_username  => 'vspheredb',
#     db_password  => 'supersecret',
#   }
#
class icingaweb2::module::vspheredb (
  Enum['mysql']                              $db_type,
  Enum['absent', 'present']                  $ensure           = 'present',
  Enum['git', 'none', 'package']             $install_method   = 'git',
  Optional[String[1]]                        $package_name     = undef,
  Stdlib::HTTPUrl                            $git_repository   = 'https://github.com/Icinga/icingaweb2-module-vspheredb.git',
  Optional[String[1]]                        $git_revision     = undef,
  Boolean                                    $manage_service   = true,
  Stdlib::Ensure::Service                    $service_ensure   = 'running',
  Boolean                                    $service_enable   = true,
  String[1]                                  $service_user     = 'icingavspheredb',
  String[1]                                  $db_resource_name = 'vspheredb',
  Stdlib::Host                               $db_host          = 'localhost',
  String[1]                                  $db_name          = 'vspheredb',
  String[1]                                  $db_username      = 'vspheredb',
  Optional[Icinga::Secret]                   $db_password      = undef,
  Optional[Stdlib::Port]                     $db_port          = undef,
  Optional[String[1]]                        $db_charset       = undef,
  Optional[Icingaweb2::ImportSchema]         $import_schema    = undef,
  Stdlib::Absolutepath                       $module_dir       = "${icingaweb2::globals::default_module_path}/vspheredb",
  Optional[Boolean]                          $use_tls          = undef,
  Optional[Stdlib::Absolutepath]             $tls_key_file     = undef,
  Optional[Stdlib::Absolutepath]             $tls_cert_file    = undef,
  Optional[Stdlib::Absolutepath]             $tls_cacert_file  = undef,
  Optional[Stdlib::Absolutepath]             $tls_capath       = undef,
  Optional[Icinga::Secret]                   $tls_key          = undef,
  Optional[String[1]]                        $tls_cert         = undef,
  Optional[String[1]]                        $tls_cacert       = undef,
  Optional[Boolean]                          $tls_noverify     = undef,
  Optional[String[1]]                        $tls_cipher       = undef,
) {
  require icingaweb2

  $module_conf_dir = "${icingaweb2::globals::conf_dir}/modules/vspheredb"
  $cert_dir        = "${icingaweb2::globals::state_dir}/vspheredb/certs"

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
    'icingaweb2-module-vspheredb' => {
      'section_name' => 'db',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => {
        'resource' => $db_resource_name,
      },
    },
  }

  class { 'icingaweb2::module::vspheredb::install': }
  -> class { 'icingaweb2::module::vspheredb::config': }
  ~> class { 'icingaweb2::module::vspheredb::service': }
  contain icingaweb2::module::vspheredb::install
  contain icingaweb2::module::vspheredb::config
  contain icingaweb2::module::vspheredb::service
}
