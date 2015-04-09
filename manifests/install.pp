# == Class icingaweb2::install
#
class icingaweb2::install {
  if is_function_available('assert_private') {
    assert_private()
  } else {
    private()
  }

  if $::icingaweb2::install_method == 'package' {
    if $::icingaweb2::pkg_list {
      package { $::icingaweb2::pkg_list:
        ensure => $::icingaweb2::pkg_ensure,
      }
    }

    if $::icingaweb2::pkg_deps {
      package { $::icingaweb2::pkg_deps:
        ensure => $::icingaweb2::pkg_ensure,
        before => Package[$::icingaweb2::pkg_list],
      }
    }
  }

  if $::icingaweb2::install_method == 'git' {
    if $::icingaweb2::pkg_deps {
      package { $::icingaweb2::pkg_deps:
        ensure => $::icingaweb2::pkg_ensure,
        before => Vcsrepo['icingaweb2'],
      }
    }

    vcsrepo { 'icingaweb2':
      ensure   => present,
      path     => $::icingaweb2::web_root,
      provider => 'git',
      revision => $::icingaweb2::git_revision,
      source   => $::icingaweb2::git_repo,
    }
  }

#       #Load the MySQL DB schema:
#       exec { 'mysql_schema_load':
#         user    => 'root',
#         path    => '/usr/bin:/usr/sbin:/bin/:/sbin',
#         command => "mysql -u ${db_user} -p${db_password} ${db_name} < ${server_db_schema_path} && touch /etc/icinga2/mysql_schema_loaded.txt",
#         creates => '/etc/icinga2/mysql_schema_loaded.txt',
#         require => Class['icinga2::server::install::packages'],
#       }

  # mysql -uicinga2 -ppassword icinga2_auth < /usr/share/doc/icingaweb2/schema/mysql.schema.sql


}

