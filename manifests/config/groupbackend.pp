# == Define: icingaweb2::config::groupbackend
#
#  Groups of users can be stored either in a database, LDAP or ActiveDirectory. This defined type configures backends
#  that store groups.
#
# === Parameters
#
# [*group_name*]
#   Name of the resources. Resources are referenced by their name in other configuration sections.
#
# [*backend*]
#   Type of backend. Valide values are: `db`, `ldap` and `msldap`. Each backend supports different settings, see the
#   parameters for detailed information.
#
# [*resource*]
#   The resource used to connect to the backend. The resource contains connection information.
#
# [*ldap_user_backend*]
#   A group backend can be connected with an authentication method. This parameter references the auth method. Only
#   valid with backend `ldap` or `msldap`.
#
# [*ldap_group_class*]
#   Class used to identify group objects. Only valid with backend `ldap`.
#
# [*ldap_group_filter*]
#   Use a LDAP filter to receive only certain groups. Only valid with backend `ldap` or `msldap`.
#
# [*ldap_group_name_attribute*]
#   The group name attribute. Only valid with backend `ldap`.
#
# [*ldap_group_member_attribute*]
#   The group member attribute. Only valid with backend `ldap`.
#
# [*ldap_base_dn*]
#   Base DN that is searched for groups. Only valid with backend `ldap` with `msldap`.
#
# [*ldap_nested_group_search*]
#   Search for groups in groups. Only valid with backend `msldap`.
#
# === Examples
#
# A group backend for groups stored in LDAP:
#
# icingaweb2::config::groupbackend {'ldap-backend':
#   backend                     => 'ldap',
#   resource                    => 'my-ldap',
#   ldap_group_class            => 'groupofnames',
#   ldap_group_name_attribute   => 'cn',
#   ldap_group_member_attribute => 'member',
#   ldap_base_dn                => 'ou=groups,dc=icinga,dc=com'
# }
#
#
define icingaweb2::config::groupbackend(
  $group_name                  = $title,
  $backend                     = undef,
  $resource                    = undef,
  $ldap_user_backend           = undef,
  $ldap_group_class            = undef,
  $ldap_group_filter           = undef,
  $ldap_group_name_attribute   = undef,
  $ldap_group_member_attribute = undef,
  $ldap_base_dn                = undef,
  $ldap_nested_group_search    = undef,
) {

  $conf_dir = $::icingaweb2::params::conf_dir

  validate_re($backend, [ 'db', 'ldap', 'msldap' ],
    "${backend} isn't supported. Valid values are 'db', 'ldap' and 'msldap'.")
  validate_string($resource)
  if $ldap_user_backend { validate_string($ldap_user_backend) }
  if $ldap_group_class { validate_string($ldap_group_class) }
  if $ldap_group_filter { validate_string($ldap_group_filter) }
  if $ldap_group_name_attribute { validate_string($ldap_group_name_attribute) }
  if $ldap_group_member_attribute { validate_string($ldap_group_member_attribute) }
  if $ldap_base_dn { validate_string($ldap_base_dn) }
  if $ldap_nested_group_search { validate_bool($ldap_nested_group_search) }


  case $backend {
    'db': {
      $settings = {
        'backend'  => $backend,
        'resource' => $resource,
      }
    }
    'ldap': {
      $settings = {
        'backend'                => $backend,
        'resource'               => $resource,
        'user_backend'           => $ldap_user_backend,
        'group_class'            => $ldap_group_class,
        'group_filter'           => $ldap_group_filter,
        'group_name_attribute'   => $ldap_group_name_attribute,
        'group_member_attribute' => $ldap_group_member_attribute,
        'base_dn'                => $ldap_base_dn,
      }
    }
    'msldap': {
      $ldap_nested_group_search_as_string = $ldap_nested_group_search ? {
        true    => '1',
        default => '0',
      }

      $settings = {
        'backend'             => $backend,
        'resource'            => $resource,
        'user_backend'        => $ldap_user_backend,
        'nested_group_search' => $ldap_nested_group_search_as_string,
        'group_filter'        => $ldap_group_filter,
        'base_dn'             => $ldap_base_dn,
      }
    }
    default: {
      fail('The backend type you provided is not supported.')
    }
  }

  icingaweb2::inisection { $title:
    target   => "${conf_dir}/groups.ini",
    settings => delete_undef_values($settings),
  }
}