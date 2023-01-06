# @summary
#   Create and remove Icinga Web 2 database resources.
#
# @param resource_name
#   Name of the resources. Resources are referenced by their name in other configuration sections.
#
# @param type
#   Set database type to connect.
#
# @param host
#   Connect to the database on the given host. For using unix domain sockets, specify 'localhost' for
#   MySQL and the path to the unix domain socket and the directory for PostgreSQL.
#
# @param port
#   Port number to use.
#
# @param database
#   The database to use.
#
# @param username
#   The username to use when connecting to the server.
#
# @param password
#   The password to use when connecting the database.
#
# @param charset
#   The character set to use for the database connection.
#
# @param use_tls
#   Either enable or disable TLS encryption to the database. Other TLS parameters
#   are only affected if this is set to 'true'.
#
# @param tls_noverify
#   Disable validation of the server certificate.
#
# @param tls_key
#   Location of the private key for client authentication. Only valid if tls is enabled.
#
# @param tls_cert
#   Location of the certificate for client authentication. Only valid if tls is enabled.
#
# @param tls_cacert
#   Location of the ca certificate. Only valid if tls is enabled.
#
# @param tls_capath
#   The file path to the directory that contains the trusted SSL CA certificates, which are stored in PEM format.
#   Only available for the mysql database.
#
# @param tls_cipher
#   Chipher to use for the encrypted database connection.
#
# @example Create a MySQL DB resource:
#   icingaweb2::resource::database { 'mysql':
#     type     => 'mysql',
#     host     => 'localhost',
#     port     => '3306',
#     database => 'icingaweb2',
#     username => 'icingaweb2',
#     password => 'supersecret',
#   }
#
define icingaweb2::resource::database (
  Enum['mysql', 'pgsql', 'mssql',
  'oci', 'oracle', 'ibm', 'sqlite']  $type,
  String                             $database,
  Stdlib::Port                       $port,
  String                             $resource_name = $title,
  Stdlib::Host                       $host          = undef,
  Optional[String]                   $username      = undef,
  Optional[Icingaweb2::Secret]       $password      = undef,
  Optional[String]                   $charset       = undef,
  Optional[Boolean]                  $use_tls       = undef,
  Optional[Boolean]                  $tls_noverify  = undef,
  Optional[Stdlib::Absolutepath]     $tls_key       = undef,
  Optional[Stdlib::Absolutepath]     $tls_cert      = undef,
  Optional[Stdlib::Absolutepath]     $tls_cacert    = undef,
  Optional[Stdlib::Absolutepath]     $tls_capath    = undef,
  Optional[String]                   $tls_cipher    = undef,
) {
  $conf_dir = $icingaweb2::globals::conf_dir

  $settings = {
    'type'                          => 'db',
    'db'                            => $type,
    'host'                          => $host,
    'port'                          => $port,
    'dbname'                        => $database,
    'username'                      => $username,
    'password'                      => icingaweb2::unwrap($password),
    'charset'                       => $charset,
    'use_ssl'                       => $use_tls,
    'ssl_do_not_verify_server_cert' => $tls_noverify,
    'ssl_cert'                      => $tls_cert,
    'ssl_key'                       => $tls_key,
    'ssl_ca'                        => $tls_cacert,
    'ssl_capath'                    => $tls_capath,
    'ssl_cipher'                    => $tls_cipher,
  }

  icingaweb2::inisection { "resource-${resource_name}":
    section_name => $resource_name,
    target       => "${conf_dir}/resources.ini",
    settings     => delete_undef_values($settings),
  }
}
