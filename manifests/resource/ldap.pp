# @summary
#   Create and remove Icinga Web 2 resources. Resources may be referenced in other configuration sections.
#
# @param resource_name
#   Name of the resources. Resources are referenced by their name in other configuration sections.
#
# @param host
#   Connect to the database or ldap server on the given host. For using unix domain sockets, specify 'localhost' for
#   MySQL and the path to the unix domain socket directory for PostgreSQL. When using the 'ldap' type you can also
#   provide multiple hosts separated by a space.
#
# @param port
#   Port number to use.
#
# @param root_dn
#   Root object of the tree, e.g. 'ou=people,dc=icinga,dc=com'.
#
# @param bind_dn
#   The user to use when connecting to the server.
#
# @param bind_pw
#   The password to use when connecting to the server.
#
# @param encryption
#   Type of encryption to use: none (default), starttls, ldaps.
#
# @param timeout
#   Timeout for the ldap connection.
#
# @example Create a LDAP resource:
#   icingaweb2::resource::ldap{ 'my-ldap':
#     host    => 'localhost',
#     port    => 389,
#     root_dn => 'ou=users,dc=icinga,dc=com',
#     bind_dn => 'cn=icingaweb2,ou=users,dc=icinga,dc=com',
#     bind_pw => Sensitive('supersecret'),
#   }
#
define icingaweb2::resource::ldap (
  String                            $resource_name = $title,
  String                            $host          = 'localhost',
  Optional[Stdlib::Port]            $port          = undef,
  Optional[String]                  $root_dn       = undef,
  Optional[String]                  $bind_dn       = undef,
  Optional[Icingaweb2::Secret]      $bind_pw       = undef,
  Enum['none', 'starttls', 'ldaps'] $encryption    = 'none',
  Integer                           $timeout       = 5,
) {
  $conf_dir = $icingaweb2::globals::conf_dir
  $settings = {
    'type'       => 'ldap',
    'hostname'   => $host,
    'port'       => $port,
    'root_dn'    => $root_dn,
    'bind_dn'    => $bind_dn,
    'bind_pw'    => icingaweb2::unwrap($bind_pw),
    'encryption' => $encryption,
    'timeout'    => $timeout,
  }

  icingaweb2::inisection { "resource-${resource_name}":
    section_name => $resource_name,
    target       => "${conf_dir}/resources.ini",
    settings     => delete_undef_values($settings),
  }
}
