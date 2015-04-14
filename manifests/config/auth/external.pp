#
#
#
#

define icingaweb2::config::auth::external(
  $auth_section    = undef,
  $strip_username  = undef

) inherits icingaweb2::params {

#   concat::fragment {
#     "icingaweb2_ext_authentication_CONTENT":
#       target  => "icingaweb2_authentication.ini",
#       content => template( 'icingaweb2/authentication/external.erb' ),
#       order   => 30
#   }

}

# EOF
