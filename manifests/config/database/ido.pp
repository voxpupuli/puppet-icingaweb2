#
#
#
#

class icingaweb2::config::database::ido (
  $db_type     = 'mysql',       # mysql , maybe postgres?
  $db_host     = 'localhost',
  $db_port     = '3306',
  $db_schema   = undef,         # icinga2_data
  $db_username = undef,         # ..
  $db_password = undef          # ..
) {

  validate_re( $db_type, '^(mysql)$', "\$db_type must be either 'mysql', got '${db_type}'")
  validate_string( $db_host )
  validate_re( $db_port, '^[0-9]+$' )
  validate_string( $db_schema )
  validate_string( $db_username )
  validate_string( $db_password )
  validate_string( $db_prefix )

  $db_resource = 'icinga_ido'

  concat::fragment {
    "icingaweb2_resources_dba_ido_CONTENT":
      target  => "icingaweb2_resources",
      content => template( 'icingaweb2/resources/database.erb' ),
      order   => 20
  }

}

# EOF
