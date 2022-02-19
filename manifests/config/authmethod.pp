# @summary
#   Manage Icinga Web 2 authentication methods. Auth methods may be chained by setting proper ordering.
#
# @param backend
#   Select between 'external', 'ldap', 'msldap' or 'db'. Each backend may require other settings.
#
# @param resource
#   The name of the resource defined in resources.ini.
#
# @param ldap_user_class
#   LDAP user class. Only valid if `backend` is `ldap` or `msldap`.
#
# @param ldap_user_name_attribute
#   LDAP attribute which contains the username. Only valid if `backend` is `ldap` or `msldap`.
#
# @param ldap_filter
#   LDAP search filter. Only valid if `backend` is `ldap` or `msladap`.
#
# @param ldap_base_dn
#   LDAP base DN. Only valid if `backend` is `ldap` or `msldap`.
#
# @param domain
#   Domain for domain-aware authentication
#
# @param order
#   Multiple authentication methods can be chained. The order of entries in the authentication
#   configuration determines the order of the authentication methods.
#
# @example Create an authentication method (db) and reference to a resource:
#   icingaweb2::config::authmethod { 'db-auth':
#     backend  => 'db',
#     resource => 'my-sql',
#     order    => 20,
#   }
#
# @example Create a LDAP authmethod:
#   icingaweb2::config::authmethod { 'ldap-auth':
#     backend                  => 'ldap',
#     resource                 => 'my-ldap',
#     ldap_user_class          => 'user',
#     ldap_filter              => '(memberof:1.2.840.113556.1.4.1941:=CN=monitoring,OU=groups,DC=icinga,DC=com)',
#     ldap_user_name_attribute => 'userPrincipalName',
#     order                    => '05',
#   }
#
define icingaweb2::config::authmethod(
  Enum['external', 'ldap', 'msldap', 'db'] $backend                  = undef,
  Optional[String]                         $resource                 = undef,
  Optional[String]                         $ldap_user_class          = undef,
  Optional[String]                         $ldap_user_name_attribute = undef,
  Optional[String]                         $ldap_filter              = undef,
  Optional[String]                         $ldap_base_dn             = undef,
  Optional[String]                         $domain                   = undef,
  Variant[String, Integer]                 $order                    = '01',
) {

  $conf_dir = $::icingaweb2::globals::conf_dir

  case $backend {
    'external': {
      $settings = {
        'backend' => $backend,
      }
    }
    'ldap', 'msldap': {
      $settings = {
        'backend'             => $backend,
        'resource'            => $resource,
        'user_class'          => $ldap_user_class,
        'user_name_attribute' => $ldap_user_name_attribute,
        'filter'              => $ldap_filter,
        'base_dn'             => $ldap_base_dn,
        'domain'              => $domain,
      }
    }
    'db': {
      $settings = {
        'backend'  => $backend,
        'resource' => $resource,
        'domain'   => $domain,
      }
    }
    default: {
      fail('The backend type you provided is not supported.')
    }
  }

  icingaweb2::inisection { "authmethod-${title}":
    section_name => $title,
    target       => "${conf_dir}/authentication.ini",
    settings     => delete_undef_values($settings),
    order        => $order,
  }

}
