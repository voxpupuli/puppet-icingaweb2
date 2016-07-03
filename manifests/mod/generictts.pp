# == Class icingaweb2::mod::generictts
#
define icingaweb2::mod::generictts_section (
  $pattern = '/#([0-9]{4,6})/',
  $url     = undef,
) {
  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/modules/generictts"],
    path    => "${::icingaweb2::config_dir}/modules/generictts/config.ini",
  }

  ini_setting { 'generictts_pattern':
    section => $name,
    setting => 'pattern',
    value   => $pattern,
  }

  ini_setting { 'generictts_url':
    section => $name,
    setting => 'url',
    value   => $url,
  }
}

class icingaweb2::mod::generictts (
  $git_repo             = 'https://github.com/icinga/icingaweb2-module-generictts.git',
  $git_revision         = undef,
  $generictts_sections  = undef,
  $install_method       = 'git',
  $pkg_deps             = undef,
  $pkg_ensure           = 'present',
  $web_root             = $::icingaweb2::params::web_root,
) {
  require ::icingaweb2

  validate_hash($generictts_sections)
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
    "${web_root}/modules/generictts":
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;

    "${::icingaweb2::config_dir}/modules/generictts":
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;

    "${::icingaweb2::config_dir}/enabledModules/generictts":
      ensure => link,
      target => '/usr/share/icingaweb2/modules/generictts';
  }

  create_resources(icingaweb2::mod::generictts_section, $generictts_sections)

  if $install_method == 'git' {
    if $pkg_deps {
      package { $pkg_deps:
        ensure => $pkg_ensure,
        before => Vcsrepo['generictts'],
      }
    }

    vcsrepo { 'generictts':
      ensure   => present,
      path     => "${web_root}/modules/generictts",
      provider => 'git',
      revision => $git_revision,
      source   => $git_repo,
    }
  }
}

