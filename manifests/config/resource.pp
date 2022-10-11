# @summary
#   Create and remove Icinga Web 2 resources. Resources may be referenced in other configuration sections.
#
# @param resource_name
#   Name of the resources. Resources are referenced by their name in other configuration sections.
#
# @param type
#   Supported resource types are `db` and `ldap`.
#
# @param host
#   Connect to the database or ldap server on the given host. For using unix domain sockets, specify 'localhost' for
#   MySQL and the path to the unix domain socket directory for PostgreSQL. When using the 'ldap' type you can also
#   provide multiple hosts separated by a space.
#
# @param port
#   Port number to use.
#
# @param db_type
#   Set database type to connect.
#
# @param db_name
#   The database to use. Only valid if `type` is `db`.
#
# @param db_username
#   The username to use when connecting to the server. Only valid if `type` is `db`.
#
# @param db_password
#   The password to use when connecting to the server. Only valid if `type` is `db`.
#
# @param db_charset
#   The character set to use for the database connection. Only valid if `type` is `db`.
#
# @param ldap_root_dn
#   Root object of the tree, e.g. 'ou=people,dc=icinga,dc=com'. Only valid if `type` is `ldap`.
#
# @param ldap_bind_dn
#   The user to use when connecting to the server. Only valid if `type` is `ldap`.
#
# @param ldap_bind_pw
#   The password to use when connecting to the server. Only valid if `type` is `ldap`.
#
# @param ldap_encryption
#   Type of encryption to use: none (default), starttls, ldaps. Only valid if `type` is `ldap`.
#
# @param ldap_timeout
#   Timeout for the ldap connection.
#
# @example Create a MySQL DB resource:
#   icingaweb2::config::resource{ 'my-sql':
#     type        => 'db',
#     db_type     => 'mysql',
#     host        => 'localhost',
#     port        => '3306',
#     db_name     => 'icingaweb2',
#     db_username => 'icingaweb2',
#     db_password => 'supersecret',
#   }
#
# @example Create a LDAP resource:
#   icingaweb2::config::resource{ 'my-ldap':
#     type         => 'ldap',
#     host         => 'localhost',
#     port         => 389,
#     ldap_root_dn => 'ou=users,dc=icinga,dc=com',
#     ldap_bind_dn => 'cn=icingaweb2,ou=users,dc=icinga,dc=com',
#     ldap_bind_pw => 'supersecret',
#   }
#
define icingaweb2::config::resource(
  Enum['db', 'ldap']                          $type,
  String                                      $resource_name   = $title,
  Optional[String]                            $host            = undef,
  Optional[Stdlib::Port]                      $port            = undef,
  Optional[Enum['mysql', 'pgsql', 'mssql',
    'oci', 'oracle', 'ibm', 'sqlite']]        $db_type         = undef,
  Optional[String]                            $db_name         = undef,
  Optional[String]                            $db_username     = undef,
  Optional[Icingaweb2::Secret]                $db_password     = undef,
  Optional[String]                            $db_charset      = undef,
  Optional[String]                            $ldap_root_dn    = undef,
  Optional[String]                            $ldap_bind_dn    = undef,
  Optional[Icingaweb2::Secret]                $ldap_bind_pw    = undef,
  Optional[Enum['none', 'starttls', 'ldaps']] $ldap_encryption = 'none',
  Integer                                     $ldap_timeout    = 5,
) {
  if $type == 'db' {
    deprecation('icingaweb2::config::resource', 'This icingaweb2::config::resource is deprecated and will be replaced for type=db by icingaweb2::resource::database in the future.')
  } else {
    deprecation('icingaweb2::config::resource', 'This icingaweb2::config::resource is deprecated and will be replaced for type=ldap by icingaweb2::resource::ldap in the future.')
  }

  $conf_dir = $::icingaweb2::globals::conf_dir

  case $type {
    'db': {
      $settings = {
        'type'     => $type,
        'db'       => $db_type,
        'host'     => $host,
        'port'     => $port,
        'dbname'   => $db_name,
        'username' => $db_username,
        'password' => icingaweb2::unwrap($db_password),
        'charset'  => $db_charset,
      }
    }
    'ldap': {
      $settings = {
        'type'       => $type,
        'hostname'   => $host,
        'port'       => $port,
        'root_dn'    => $ldap_root_dn,
        'bind_dn'    => $ldap_bind_dn,
        'bind_pw'    => icingaweb2::unwrap($ldap_bind_pw),
        'encryption' => $ldap_encryption,
        'timeout'    => $ldap_timeout,
      }
    }
    default: {
      fail('The resource type you provided is not supported.')
    }
  }

  icingaweb2::inisection { "resource-${resource_name}":
    section_name => $resource_name,
    target       => "${conf_dir}/resources.ini",
    settings     => delete_undef_values($settings),
  }

}
