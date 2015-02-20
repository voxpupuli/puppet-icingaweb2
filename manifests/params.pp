# == Class icingaweb2::params
#
class icingaweb2::params {
  $git_repo            = 'https://git.icinga.org/icingaweb2.git'
  $git_revision         = undef
  $install_method      = 'git'
  $manage_apache_vhost = false
  $manage_repo         = false

  $ido_db      = 'mysql'
  $ido_db_host = 'localhost'
  $ido_db_name = 'icingaweb2'
  $ido_db_pass = 'icingaweb2'
  $ido_db_port = '3306'
  $ido_db_user = 'icingaweb2'
  $ido_type    = 'db'

  $web_db        = 'mysql'
  $web_db_host   = 'localhost'
  $web_db_name   = 'icingaweb2'
  $web_db_pass   = 'icingaweb2'
  $web_db_port   = '3306'
  $web_db_prefix = 'icingaweb2_'
  $web_db_user   = 'icingaweb2'
  $web_type      = 'db'

  case $::osfamily {
    'RedHat': {
      $config_dir         = '/etc/icingaweb2'
      $config_dir_mode    = '0755'
      $config_dir_recurse = false
      $config_file_mode   = '0644'
      $config_group       = 'root'
      $config_user        = 'root'
      $pkg_deps           = []
      $pkg_ensure         = present
      $pkg_list           = []
      $web_root           = '/usr/share/icingaweb2'
    }

    'Debian': {
      $config_dir         = '/etc/icingaweb2'
      $config_dir_mode    = '0755'
      $config_dir_recurse = false
      $config_file_mode   = '0644'
      $config_group       = 'root'
      $config_user        = 'root'
      $pkg_deps           = []
      $pkg_ensure         = present
      $pkg_list           = []
      $web_root           = '/usr/share/icingaweb2'
    }

    default: {
      fail "Operating system ${::operatingsystem} is not supported."
    }
  }
}

