# == Class icingaweb2::initialize
#
# This class is used to initialize a default icingaweb2 db and user
# Depends on the pupppetlabs-mysql module
class icingaweb2::initialize {
  if $::icingaweb2::initialize {

    Exec {
      path => $::path,
    }

    unless $::osfamily =~ /^(Debian|RedHat)$/ {
      fail("Database initialization not implemented on osfamily ${::osfamily}!")
    }

    $_icingaadmin_default_password = '$1$EzxLOFDr$giVx3bGhVm4lDUAw6srGX1' # icinga
    $_escaped_icingaadmin_password = shell_escape($_icingaadmin_default_password)

    if $::icingaweb2::web_db == 'mysql' {
      if $::icingaweb2::install_method == 'git' or $::osfamily == 'Debian' {
        $_sql_schema_location = '/usr/share/icingaweb2/etc/schema/mysql.schema.sql'
      } else {
        $_sql_schema_location = '/usr/share/doc/icingaweb2/schema/mysql.schema.sql'
      }

      $_mysql_command = join([
        'mysql',
        '-h', shell_escape($::icingaweb2::web_db_host),
        '-u', shell_escape($::icingaweb2::web_db_user),
        #'-p', shell_escape($::icingaweb2::web_db_pass), TODO: remove
        shell_escape($::icingaweb2::web_db_name),
      ], ' ')
      $_mysql_environment = "MYSQL_PWD=${::icingaweb2::web_db_pass}"

      exec { 'icingaweb2 create db schema':
        command     => "${_mysql_command} < ${_sql_schema_location}",
        unless      => "${_mysql_command} -e 'SELECT 1 FROM icingaweb_user LIMIT 1;'",
        environment => $_mysql_environment,
      } ~>

      exec { 'icingaweb2 create default web user':
        command     => "${_mysql_command} -e \"INSERT INTO icingaweb_user (name, active, password_hash)
                     VALUES ('icingaadmin', 1, '${_escaped_icingaadmin_password}');\"",
        environment => $_mysql_environment,
        refreshonly => true,
      }
    } else {
      fail("database initialization is not supported for web_db ${::icingaweb2::web_db}")
    }
  }
}
