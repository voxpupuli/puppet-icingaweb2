# == Define: icingaweb2::config::authmethod
#
# Manage Icinga Web 2 authentication methods. Auth methods may be chained by setting proper ordering. Some backends
# require additional resources.
#
# === Parameters
#
# [*backend*]
#   Select between 'external', 'ldap', 'msldap' or 'db'. Each backend may require other settings.
#
# [*resource*]
#   The name of the resource defined in resources.ini.
#
# [*ldap_user_class*]
#   LDAP user class. Only valid if `backend` is `ldap`.
#
# [*ldap_user_name_attribute*]
#   LDAP attribute which contains the username. Only valid if `backend` is `ldap`.
#
# [*ldap_filter*]
#   LDAP search filter. Only valid if `backend` is `ldap`.
#
# [*order*]
#   Multiple authentication methods can be chained. The order of entries in the authentication configuration determines
#   the order of the authentication methods. Defaults to `01`
#
# === Examples
#
# Create a 'db' authentication method and reference to 'my-sql' resource:
#
# icingaweb2::config::authmethod {'db-auth':
#   backend  => 'db',
#   resource => 'my-sql',
#   order    => '02',
# }
#
define icingaweb2::config::authmethod(
  $backend                  = undef,
  $resource                 = undef,
  $ldap_user_class          = undef,
  $ldap_user_name_attribute = undef,
  $ldap_filter              = undef,
  $order                    = '01',
) {

  $conf_dir = $::icingaweb2::params::conf_dir

  validate_re($backend, [ 'external', 'ldap', 'msldap', 'db' ],
    "${backend} isn't supported. Valid values are 'external', 'ldap', 'msldap' and 'db'.")
  validate_string($order)

  case $backend {
    'external': {
      $settings = {
        'backend' => $backend,
      }
    }
    'ldap': {
      validate_string($resource)
      validate_string($ldap_user_class)
      validate_string($ldap_user_name_attribute)
      validate_string($ldap_filter)

      $settings = {
        'backend'             => $backend,
        'resource'            => $resource,
        'user_class'          => $ldap_user_class,
        'user_name_attribute' => $ldap_user_name_attribute,
        'filter'              => $ldap_filter,
      }
    }
    'msldap', 'db': {
      validate_string($resource)

      $settings = {
        'backend'  => $backend,
        'resource' => $resource,
      }
    }
    default: {
      fail('The backend type you provided is not supported.')
    }
  }

  icingaweb2::inisection { $title:
    target   => "${conf_dir}/authentication.ini",
    settings => delete_undef_values($settings),
    order    => $order,
  }
}
