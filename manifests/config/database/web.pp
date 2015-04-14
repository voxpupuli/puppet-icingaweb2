#
#
#
#
#

class icingaweb2::config::database::web (
  $db_type     = 'mysql',       # mysql , maybe postgres?
  $db_host     = 'localhost',
  $db_port     = '3306',
  $db_schema   = undef,         # icingaweb2_auth
  $db_username = undef,         # ..
  $db_password = undef,         # ..
  $db_prefix   = undef,         # icingaweb_
) {

  validate_re( $db_type, '^(mysql)$', "\$db_type must be either 'mysql', got '${db_type}'")
  validate_string( $db_host )
  validate_re( $db_port, '^[0-9]+$' )
  validate_string( $db_schema )
  validate_string( $db_username )
  validate_string( $db_password )
  validate_string( $db_prefix )

  $db_resource = 'icingaweb_db'

  concat::fragment {
    "icingaweb2_resources_dba_web_CONTENT":
      target  => "icingaweb2_resources",
      content => template( 'icingaweb2/resources/database.erb' ),
      order   => 20
  }

  # this part was used to store user configs in database
  $db_schema_file = '/usr/share/doc/icingaweb2/schema/mysql.schema.sql'

  exec {
    'icingaweb2_mysql_schema_load':
      path     => [
        '/bin',
        '/sbin',
        '/usr/bin',
        '/usr/sbin'
      ],
      command  => "mysql -u ${db_username} -p${db_password} -h ${db_host} ${db_schema} < ${db_schema_file} && touch ${::icingaweb2::config_dir}/mysql_schema_loaded.txt",
      creates  => "${::icingaweb2::config_dir}/mysql_schema_loaded.txt",
      require  => Class['icingaweb2::install']
  }

}

# EOF
