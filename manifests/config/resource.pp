# == Define: icingaweb2::inifile
#
# Create and remove Icinga Web 2 resources. Resources may be referenced in other configuration sections.
#
# === Parameters
#
# [*ensure*]
#   Set to present creates the resource, absent removes it. Defaults to present.
#
# [*name*]
#   Name of the resources. Resources are referenced by their name in other configuration sections.
#
# [*type*]
#   Supported resource types are `db` and `ldap`.
#
# [*host*]
#   Connect to the database or ldap server on the given host. For using unix domain sockets, specify 'localhost' for
#   MySQL and the path to the unix domain socket directory for PostgreSQL. When using the 'ldap' type you can also
#   provide multiple hosts separated by a space.
#
# [*port*]
#   Port number to use.
#
# [*db_type*]
#   Supported DB types are `mysql` and `pgsql`.
#
# [*db_name*]
#   The database to use.
#
# [*db_username*]
#   The username to use when connecting to the server.
#
# [*db_password*]
#   The password to use when connecting to the server.
#
# [*db_charset*]
#   The character set to use for the database connection.
#
# [*ldap_root_dn*]
#   Root object of the tree, e.g. 'ou=people,dc=icinga,dc=com'
#
# [*ldap_bind_dn*]
#   The user to use when connecting to the server.
#
# [*ldap_bind_pw*]
#   The password to use when connecting to the server.
#
# [*ldap_encryption*]
#   Type of encryption to use: none (default), starttls, ldaps.
#
# === Examples
#
# Create a 'db' resource:
#
# icingaweb2::config::resource{'my-sql':
#   ensure      => present,
#   type        => 'db',
#   db_type     => 'mysql',
#   host        => 'localhost',
#   port        => '3306',
#   db_name     => 'icingaweb2',
#   db_username => 'root',
#   db_password => 'supersecret',
# }
#
#
define icingaweb2::config::resource(
  $ensure          = present,
  $resource_name   = $title,
  $type            = undef,
  $host            = undef,
  $port            = undef,
  $db_type         = undef,
  $db_name         = undef,
  $db_username     = undef,
  $db_password     = undef,
  $db_charset      = undef,
  $ldap_root_dn    = undef,
  $ldap_bind_dn    = undef,
  $ldap_bind_pw    = undef,
  $ldap_encryption = 'none',
) {

  $conf_dir = $::icingaweb2::params::conf_dir

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_string($name)
  validate_re($type, [ 'db', 'ldap' ],
    "${type} isn't supported. Valid values are 'db' and 'ldap'.")
  validate_string($host)
  validate_integer($port)

  case $type {
    'db': {
      validate_re($db_type, [ 'mysql', 'pgsql' ],
        "${db_type} isn't supported. Valid values are 'mysql' and 'pgsql'.")
      validate_string($db_username)
      validate_string($db_password)
      validate_string($db_name)
      if $db_charset { validate_string($db_charset) }

      $type_settings = {
        'type'     => $type,
        'host'     => $host,
        'port'     => $port,
        'username' => $db_username,
        'password' => $db_password,
        'dbname'   => $db_name,
        'charset'  => $db_charset,
      }
    }
    'ldap': {
      validate_string($ldap_root_dn)
      validate_string($ldap_bind_dn)
      validate_string($ldap_bind_pw)
      validate_re($ldap_encryption, [ 'none', 'starttls', 'ldaps' ],
        "${ldap_encryption} isn't supported. Valid values are 'none', 'starttls' and 'ldaps'.")

      $type_settings = {
        'type'       => $type,
        'hostname'   => $host,
        'port'       => $port,
        'root_dn'    => $ldap_root_dn,
        'bind_dn'    => $ldap_bind_dn,
        'bind_pw'    => $ldap_bind_pw,
        'encryption' => $ldap_encryption,
      }
    }
    default: {
      fail('The resource type you provided is not supported.')
    }
  }

  $settings = {
    $resource_name => delete_undef_values($type_settings)
  }

  icingaweb2::inisection { $resource_name:
    ensure   => $ensure,
    target   => "${conf_dir}/resources.ini",
    settings => $settings,
  }
}