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
            exec { 'create db scheme':
              command => "mysql -u ${::icingaweb2::web_db_user} -p${::icingaweb2::web_db_pass} ${::icingaweb2::web_db_name} < /usr/share/doc/icingaweb2/schema/mysql.schema.sql",
              onlyif  => 'test -f /root/.my.cnf',
              notify  => Exec['create web user']
            }

            exec { 'create web user':
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

