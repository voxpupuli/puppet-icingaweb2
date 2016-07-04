# == Class icingaweb2::mod::graphite
#
class icingaweb2::mod::graphite (
  $git_repo               = 'https://github.com/philiphoy/icingaweb2-module-graphite.git',
  $git_revision           = undef,
  $graphite_base_url      = 'http://graphite.com/render?',
  $graphite_metric_prefix = undef,
  $service_name_template  = undef,
  $host_name_template     = undef,
  $install_method         = 'git',
  $pkg_deps               = undef,
  $pkg_ensure             = 'present',
  $web_root               = $::icingaweb2::params::web_root,
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
    "${web_root}/modules/graphite":
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;

    "${::icingaweb2::config_dir}/modules/graphite":
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;
  }

  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/modules/graphite"],
    path    => "${::icingaweb2::config_dir}/modules/graphite/config.ini",
  }

  ini_setting { 'base_url':
    section => 'graphite',
    setting => 'base_url',
    value   => $graphite_base_url,
  }

  if $graphite_metric_prefix {
    ini_setting { 'metric_prefix':
      section => 'graphite',
      setting => 'metric_prefix',
      value   => $graphite_metric_prefix,
    }
  }

  if $service_name_template {
    ini_setting { 'service_name_template':
      section => 'graphite',
      setting => 'service_name_template',
      value   => $service_name_template,
    }
  }

  if $host_name_template {
    ini_setting { 'host_name_template':
      section => 'graphite',
      setting => 'host_name_template',
      value   => $host_name_template,
    }
  }

  file { "${::icingaweb2::config_dir}/enabledModules/graphite":
    ensure => link,
    target => '/usr/share/icingaweb2/modules/graphite'
  }


  if $install_method == 'git' {
    if $pkg_deps {
      package { $pkg_deps:
        ensure => $pkg_ensure,
        before => Vcsrepo['graphite'],
      }
    }

    vcsrepo { 'graphite':
      ensure   => latest,
      path     => "${web_root}/modules/graphite",
      provider => 'git',
      revision => $git_revision,
      source   => $git_repo,
    }
  }
}

