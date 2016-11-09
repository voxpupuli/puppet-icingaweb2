# == Class icingaweb2::params
#
class icingaweb2::params {
  # Module variables
  $git_repo            = 'https://git.icinga.org/icingaweb2.git'
  $git_revision        = undef
  $install_method      = 'git'
  $manage_apache_vhost = false
  $manage_repo         = false
  $manage_user         = true

  # Template variables
  $admin_permissions             = '*'
  $admin_users                   = 'icingaadmin'
  $auth_backend                  = 'db'
  $auth_ldap_base_dn             = undef
  $auth_ldap_filter              = undef
  $auth_ldap_user_class          = 'inetOrgPerson'
  $auth_ldap_user_name_attribute = 'uid'
  $auth_resource                 = 'icingaweb_db'
  $ido_db                        = 'mysql'
  $ido_db_host                   = 'localhost'
  $ido_db_name                   = 'icingaweb2'
  $ido_db_pass                   = 'icingaweb2'
  $ido_db_port                   = '3306'
  $ido_db_user                   = 'icingaweb2'
  $ido_type                      = 'db'
  $ldap_bind_dn                  = undef
  $ldap_bind_pw                  = undef
  $ldap_encryption               = undef
  $ldap_host                     = undef
  $ldap_port                     = '389'
  $ldap_root_dn                  = undef
  $log_application               = 'icingaweb2'
  $log_level                     = 'ERROR'
  $log_method                    = 'syslog'
  $log_resource                  = 'icingaweb_db'
  $log_store                     = 'db'
  $pkg_repo_version              = 'release'
  $template_auth                 = 'icingaweb2/authentication.ini.erb'
  $template_config               = 'icingaweb2/config.ini.erb'
  $template_resources            ='icingaweb2/resources.ini.erb'
  $template_roles                = 'icingaweb2/roles.ini.erb'
  $template_apache               = 'icingaweb2/apache2.conf.erb'
  $web_db                        = 'mysql'
  $web_db_host                   = 'localhost'
  $web_db_name                   = 'icingaweb2'
  $web_db_pass                   = 'icingaweb2'
  $web_db_port                   = '3306'
  $web_db_prefix                 = 'icingaweb2_'
  $web_db_user                   = 'icingaweb2'
  $web_type                      = 'db'
  $initialize                    = false

  case $::osfamily {
    'RedHat': {
      $config_dir                        = '/etc/icingaweb2'
      $config_dir_mode                   = '2770'
      $config_dir_purge                  = false
      $config_dir_recurse                = false
      $config_file_mode                  = '0664'
      $config_group                      = 'icingaweb2'
      $config_user                       = 'icingaweb2'
      $pkg_ensure                        = present
      $pkg_list                          = ['icingaweb2']
      $pkg_repo_release_key              = 'http://packages.icinga.org/icinga.key'
      $pkg_repo_release_metadata_expire  = undef
      $db_password_file                  = '/root/.my.cnf'

      case $::operatingsystem {
        'Scientific': {
          $pkg_repo_release_url          = "http://packages.icinga.org/epel/${::operatingsystemmajrelease}/release"
          $pkg_repo_snapshot_url         = "http://packages.icinga.org/epel/${::operatingsystemmajrelease}/snapshot"
        }
        default: {
          $pkg_repo_release_url          = 'http://packages.icinga.org/epel/$releasever/release'
          $pkg_repo_snapshot_url         = 'http://packages.icinga.org/epel/$releasever/snapshot'
        }
      }

      $pkg_repo_snapshot_key             = 'http://packages.icinga.org/icinga.key'
      $pkg_repo_snapshot_metadata_expire = '1d'
      $web_root                          = '/usr/share/icingaweb2'

      $pkg_deps = [
        'php-gd',
        'php-intl',
        'php-ldap',
        'php-mysql',
        'php-pecl-imagick',
        'php-pgsql',
      ]
    }

    'Debian': {
      $config_dir                        = '/etc/icingaweb2'
      $config_dir_mode                   = '0755'
      $config_dir_purge                  = false
      $config_dir_recurse                = false
      $config_file_mode                  = '0644'
      $config_group                      = 'icingaweb2'
      $config_user                       = 'icingaweb2'
      $pkg_ensure                        = present
      $pkg_list                          = ['icingaweb2']
      $pkg_repo_release_key              = undef
      $pkg_repo_release_metadata_expire  = undef
      $pkg_repo_release_url              = undef
      $pkg_repo_snapshot_key             = undef
      $pkg_repo_snapshot_metadata_expire = undef
      $pkg_repo_snapshot_url             = undef
      $web_root                          = '/usr/share/icingaweb2'

      $pkg_deps = [
        'php5-gd',
        'php5-imagick',
        'php5-intl',
        'php5-ldap',
        'php5-mysql',
        'php5-pgsql',
      ]
    }

    default: {
      fail "Operating system ${::operatingsystem} is not supported."
    }
  }
}

