#
#
#
#

class icingaweb2::config::auth::ldap(
  # resource
  $hostname,                    # localhost
  $port,                        # 636
  $bind_dn,                     # "cn=$ROOT-USER,dc=bar,dc=foo,dc=com"
  $bind_pw,                     # "xxxxxxxxXxxx"
  $root_dn,                     # "dc=bar,dc=foo,dc=com"
  $connection,                  # "ldaps"
  # authentication
  $base_dn,                     # "dc=bar,dc=foo,dc=com"
  $user_class,                  # "posixAccount"
  $user_name_attr               # "uid"
) {

  validate_string( $hostname )
  validate_re( $port, '^[0-9]+$' )
  validate_string( $bind_dn )
  validate_string( $bind_pw )
  validate_string( $root_dn )
  validate_re( $connection, '^(ldaps|starttls)$', "\$connection must be either 'ldaps' or 'starttls', got '${connection}'")
  validate_string( $base_dn )
  validate_string( $user_class )
  validate_string( $user_name_attr )

  concat::fragment {
    "icingaweb2_authentication_ldap_CONTENT":
      target  => "icingaweb2_authentication",
      content => template( 'icingaweb2/authentication/ldap.erb' ),
      order   => 10
  }

  concat::fragment {
    "icingaweb2_resources_ldap_CONTENT":
      target  => "icingaweb2_resources.ini",
      content => template( 'icingaweb2/resources/ldap.erb' ),
      order   => 10
  }

}

# EOF
