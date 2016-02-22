# == Class icingaweb2::initialize
#
# This class is used to initialize a default icingaweb2 db and user
# Depends on the pupppetlabs-mysql module
class icingaweb2::initialize {
  if $::icingaweb2::initialize {
    case $::operatingsystem {
      'RedHat', 'CentOS': {
        case $::icingaweb2::web_db {
          'mysql': {

            if $::icingaweb2::install_method == 'git' {
              $sql_schema_location = '/usr/share/icingaweb2/etc/schema/mysql.schema.sql'
            } else {
              $sql_schema_location = '/usr/share/doc/icingaweb2/schema/mysql.schema.sql'
            }

            exec { 'create db scheme':
              user    => 'root',
              path    => $::path,
              command => "mysql --defaults-file='/root/.my.cnf' ${::icingaweb2::web_db_name} < ${sql_schema_location}",
              unless  => "mysql --defaults-file='/root/.my.cnf' ${::icingaweb2::web_db_name} -e \"SELECT 1 FROM icingaweb_user LIMIT 1;\"",
              notify  => Exec['create web user']
            }

            exec { 'create web user':
              user        => 'root',
              path        => $::path,
              command     => "mysql --defaults-file='/root/.my.cnf' ${::icingaweb2::web_db_name} -e \" INSERT INTO icingaweb_user (name, active, password_hash) VALUES ('icingaadmin', 1, '\\\$1\\\$EzxLOFDr\\\$giVx3bGhVm4lDUAw6srGX1');\"",
              refreshonly => true,
            }
          }

          default: {
            fail "DB type ${::icingaweb2::web_db} not supported yet"
          }
        }
      }

      default: {
        fail "Managing repositories for ${::operatingsystem} is not supported."
      }
    }
  }
}
