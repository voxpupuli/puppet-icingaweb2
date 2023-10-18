# @summary
#   Installs and configures Icinga Web 2.
#
# @param logging
#   Whether Icinga Web 2 should log to 'file', 'syslog' or 'php' (web server's error log). Setting 'none' disables logging.
#
# @param logging_file
#   If 'logging' is set to 'file', this is the target log file.
#
# @param logging_level
#   Logging verbosity. Possible values are 'ERROR', 'WARNING', 'INFO' and 'DEBUG'.
#
# @param logging_facility
#   Logging facility when using syslog. Possible values are 'user' or 'local0' up to 'local7'.
#
# @param logging_application
#   Logging application name when using syslog.
#
# @param show_stacktraces
#   Whether to display stacktraces in the web interface or not.
#
# @param module_path
#   Additional path to module sources. Multiple paths must be separated by colon.
#
# @param theme
#   The default theme setting. Users may override this settings.
#
# @param theme_disabled
#   Whether users can change themes or not.
#
# @param manage_repos
#   When set to true this module will use the module icinga/puppet-icinga to manage repositories,
#   e.g. the release repo on packages.icinga.com repository by default, the EPEL repository or Backports.
#   For more information, see http://github.com/icinga/puppet-icinga.
#
# @param manage_package
#   If set to `false` packages aren't managed.
#
# @param extra_packages
#   An array of packages to install additionally.
#
# @param import_schema
#   Whether to import the MySQL schema or not. New options `mariadb` and `mysql`,
#   both means true. With mariadb its cli options are used for the import,
#   whereas with mysql its different options.
#
# @param db_type
#   Database type, can be either `mysql` or `pgsql`.
#
# @param db_host
#   Database hostname.
#
# @param db_port
#   Port to connect on the database host.
#
# @param db_name
#   Database name.
#
# @param db_username
#   Username for database access.
#
# @param db_password
#   Password for database access.
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
# @param config_backend
#   The global Icinga Web 2 preferences can either be stored in a database or in ini files. This parameter can either
#   be set to `db` or `ini`.
#
# @param conf_user
#   By default this module expects Apache2 on the server. You can change the owner of the config files with this
#   parameter.
#
# @param conf_group
#   Group membership of config files.
#
# @param default_domain
#   When using domain-aware authentication, you can set a default domain here.
#
# @param cookie_path
#   Path to where cookies are stored.
#
# @param admin_role
#   Manage a role for admin access.
#
# @param default_admin_username
#   Default username for initial admin access. This parameter is only used
#   if `import_schema` is set to `true` and only during the import itself.
#
# @param default_admin_password
#   Default password for initial admin access. This parameter is only used
#   if `import_schema` is set to `true` and only during the import itself.
#
# @param resources
#   Additional resources. Option `type` has to be set as hash key. Type of `ldap`
#   declares a define resource of `icingaweb2::resource::ldap`, a type of `mysql`, `pgsql`,
#  `oracle`, `mssql`, `ibm`, `oci`, `sqlite` goes to `icingaweb2::resource::database`.
#
# @param user_backends
#   Additional user backends for access control. See `icingaweb2::config::authmethod`.
#
# @param group_backends
#   Additional group backends for access control. See `icingaweb2::config::groupbackend`.
#
# @example Use MySQL as backend for user authentication:
#   include ::mysql::server
#
#   mysql::db { 'icingaweb2':
#     user     => 'icingaweb2',
#     password => Sensitive('supersecret'),
#     host     => 'localhost',
#     grant    => [ 'ALL' ],
#   }
#
#   class { 'icingaweb2':
#     manage_repos  => true,
#     import_schema => true,
#     db_type       => 'mysql',
#     db_host       => 'localhost',
#     db_port       => 3306,
#     db_username   => 'icingaweb2',
#     db_password   => Sensitive('supersecret'),
#     require       => Mysql::Db['icingaweb2'],
#   }
#
# @example Use PostgreSQL as backend for user authentication:
#   include ::postgresql::server
#
#   postgresql::server::db { 'icingaweb2':
#     user     => 'icingaweb2',
#     password => postgresql_password('icingaweb2', Sensitive('icingaweb2')),
#   }
#
#   class { 'icingaweb2':
#     manage_repos  => true,
#     import_schema => true,
#     db_type       => 'pgsql',
#     db_host       => 'localhost',
#     db_port       => 5432,
#     db_username   => 'icingaweb2',
#     db_password   => 'icingaweb2',
#     require       => Postgresql::Server::Db['icingaweb2'],
#   }
#
# @example Icinga Web 2 with an additional resource of type `ldap`, e.g. for authentication:
#   class { 'icingaweb2':
#     resources       => {
#       'my-ldap' => {
#         type    => 'ldap',
#         host    => 'localhost',
#         port    => 389,
#         root_dn => 'ou=users,dc=icinga,dc=com',
#         bind_dn => 'cn=icingaweb2,ou=users,dc=icinga,dc=com',
#         bind_pw => Sensitive('supersecret'),
#       }
#     },
#     user_backends   => {
#       'ldap-auth' => {
#         backend                  => 'ldap',
#         resource                 => 'my-ldap',
#         ldap_user_class          => 'user',
#         ldap_filter              => '(memberof:1.2.840.113556.1.4.1941:=CN=monitoring,OU=groups,DC=icinga,DC=com)',
#         ldap_user_name_attribute => 'userPrincipalName',
#         order                    => '05',
#       },
#     },
#     group_backends => {
#       'ldap-auth' => {
#         backend                     => 'ldap',
#         resource                    => 'my-ldap',
#         ldap_group_class            => 'group',
#         ldap_group_name_attribute   => 'cn',
#         ldap_group_member_attribute => 'member',
#         ldap_base_dn                => 'ou=groups,dc=icinga,dc=com',
#         domain                      => 'icinga.com',
#         order                       => '05',
#       },
#     },
#   }
#
class icingaweb2 (
  Stdlib::Absolutepath                            $logging_file,
  String                                          $conf_user,
  String                                          $conf_group,
  Variant[Icingaweb2::AdminRole, Boolean[false]]  $admin_role,
  String                                          $default_admin_username,
  Icingaweb2::Secret                              $default_admin_password,
  Optional[Variant[Stdlib::Absolutepath,
  Array[Stdlib::Absolutepath]]]                   $module_path         = undef,
  Enum['file', 'syslog', 'php', 'none']           $logging             = 'file',
  Enum['ERROR', 'WARNING', 'INFO', 'DEBUG']       $logging_level       = 'INFO',
  Pattern[/user|local[0-7]/]                      $logging_facility    = 'user',
  String                                          $logging_application = 'icingaweb2',
  Boolean                                         $show_stacktraces    = false,
  String                                          $theme               = 'Icinga',
  Boolean                                         $theme_disabled      = false,
  Boolean                                         $manage_repos        = false,
  Boolean                                         $manage_package      = true,
  Optional[Array[String]]                         $extra_packages      = undef,
  Variant[Boolean, Enum['mariadb', 'mysql']]      $import_schema       = false,
  Enum['mysql', 'pgsql']                          $db_type             = 'mysql',
  Stdlib::Host                                    $db_host             = 'localhost',
  Optional[Stdlib::Port]                          $db_port             = undef,
  String                                          $db_name             = 'icingaweb2',
  String                                          $db_username         = 'icingaweb2',
  Optional[Icingaweb2::Secret]                    $db_password         = undef,
  Optional[Boolean]                               $use_tls             = undef,
  Optional[Stdlib::Absolutepath]                  $tls_key_file        = undef,
  Optional[Stdlib::Absolutepath]                  $tls_cert_file       = undef,
  Optional[Stdlib::Absolutepath]                  $tls_cacert_file     = undef,
  Optional[Stdlib::Absolutepath]                  $tls_capath          = undef,
  Optional[Icingaweb2::Secret]                    $tls_key             = undef,
  Optional[String]                                $tls_cert            = undef,
  Optional[String]                                $tls_cacert          = undef,
  Optional[Boolean]                               $tls_noverify        = undef,
  Optional[String]                                $tls_cipher          = undef,
  Enum['ini', 'db']                               $config_backend      = 'ini',
  Optional[String]                                $default_domain      = undef,
  Optional[Stdlib::Absolutepath]                  $cookie_path         = undef,
  Hash[String, Hash[String, Any]]                 $resources           = {},
  Hash[String, Hash[String, Any]]                 $user_backends       = {},
  Hash[String, Hash[String, Any]]                 $group_backends      = {},
) {
  require icingaweb2::globals

  if $manage_repos {
    require icinga::repos
  }

  class { 'icingaweb2::install': }
  -> class { 'icingaweb2::config': }

  contain icingaweb2::install
  contain icingaweb2::config
}
