# == Class icingaweb2::mod::deployment
#
class icingaweb2::mod::deployment (
  $auth_token,
  $git_repo       = 'https://github.com/Thomas-Gelf/icingaweb2-module-deployment.git',
  $git_revision   = undef,
  $install_method = 'git',
  $pkg_deps       = undef,
  $pkg_ensure     = 'present',
  $web_root       = $::icingaweb2::params::web_root,
) {
  require ::icingaweb2

  validate_absolute_path($web_root)
  validate_re($install_method, '^(git|package)$')

  File {
    require => Class['::icingaweb2::config'],
    owner => $::icingaweb2::config_user,
    group => $::icingaweb2::config_group,
    mode  => $::icingaweb2::config_file_mode,
  }

  if $install_method == 'git' {
    if $pkg_deps {
      package { $pkg_deps:
        ensure => $pkg_ensure,
        before => Vcsrepo['deployment'],
      }
    }

    vcsrepo { 'deployment':
      ensure   => present,
      path     => "${web_root}/modules/deployment",
      provider => 'git',
      revision => $git_revision,
      source   => $git_repo,
    }
  }

  file { "${::icingaweb2::config_dir}/modules/deployment":
    ensure => directory,
    mode   => $::icingaweb2::config_dir_mode;
  }

  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/modules/deployment"],
    path    => "${::icingaweb2::config_dir}/modules/deployment/config.ini",
  }

  ini_setting { 'deployment auth token':
    section => 'auth',
    setting => 'token',
    value   => $auth_token,
  }
}
