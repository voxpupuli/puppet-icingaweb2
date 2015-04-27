# == Class icingaweb2::mod::nagvis
#
class icingaweb2::mod::nagvis (
  $git_repo             = 'https://github.com/divetoh/icingaweb2-module-nagvis.git',
  $git_revision         = undef,
  $nagvis_url           = 'http://example.org/nagvis/',
  $install_method       = 'git',
  $pkg_deps             = undef,
  $pkg_ensure           = 'present',
  $web_root             = $::icingaweb2::params::web_root,
) {
  require ::icingaweb2

  validate_absolute_path($web_root)
  validate_re($install_method,
    [
      'git',
    ]
  )

  File {
    require => Class['::icingaweb2::config'],
    owner => $::icingaweb2::config_user,
    group => $::icingaweb2::config_group,
    mode  => $::icingaweb2::config_file_mode,
  }

  file {
    "${web_root}/modules/nagvis":
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;

    "${::icingaweb2::config_dir}/modules/nagvis":
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;
  }

  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/modules/nagvis"],
    path    => "${::icingaweb2::config_dir}/modules/nagvis/config.ini",
  }

  ini_setting { 'nagvis_url':
    section => 'nagvis',
    setting => 'nagvis_url',
    value   => $nagvis_url,
  }

  if $install_method == 'git' {
    if $pkg_deps {
      package { $pkg_deps:
        ensure => $pkg_ensure,
        before => Vcsrepo['nagvis'],
      }
    }

    vcsrepo { 'nagvis':
      ensure   => present,
      path     => "${web_root}/modules/nagvis",
      provider => 'git',
      revision => $git_revision,
      source   => $git_repo,
    }
  }
}

