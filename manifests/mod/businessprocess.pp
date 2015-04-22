# == Class icingaweb2::mod::businessprocess
#
class icingaweb2::mod::businessprocess (
  $git_repo       = 'https://github.com/Icinga/icingaweb2-module-businessprocess.git',
  $git_revision   = undef,
  $install_method = 'git',
  $pkg_deps       = undef,
  $pkg_ensure     = 'present',
  $web_root       = $::icingaweb2::params::web_root,
) {
  require ::icingaweb2

  validate_absolute_path($web_root)
  validate_re($install_method,
    [
      'git',
      'package',
    ]
  )

  File {
    require => Class['::icingaweb2::config'],
    owner => $::icingaweb2::config_user,
    group => $::icingaweb2::config_group,
    mode  => $::icingaweb2::config_file_mode,
  }

  file { "${web_root}/modules/businessprocess":
    ensure => directory,
    mode   => $::icingaweb2::config_dir_mode;
  }

  if $install_method == 'git' {
    if $pkg_deps {
      package { $pkg_deps:
        ensure => $pkg_ensure,
        before => Vcsrepo['businessprocess'],
      }
    }

    vcsrepo { 'businessprocess':
      ensure   => present,
      path     => "${web_root}/modules/businessprocess",
      provider => 'git',
      revision => $git_revision,
      source   => $git_repo,
    }
  }
}

