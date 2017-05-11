# == Class icingaweb2::mod::grafana
#
class icingaweb2::mod::grafana (
  $host,
  $datasource,
  $defaultdashboard,
  $git_repo              = 'https://github.com/Mikesch-mp/icingaweb2-module-grafana.git',
  $git_revision          = undef,
  $username              = undef,
  $password              = undef,
  $protocol              = undef,
  $graph_height          = undef,
  $graph_width           = undef,
  $timerange             = undef,
  $enable_link           = undef,
  $defaultdashboardstore = undef,
  $accessmode            = undef,
  $timeout               = undef,
  $directrefresh         = undef,
  $install_method        = 'git',
  $pkg_deps              = undef,
  $pkg_ensure            = 'present',
  $web_root              = $::icingaweb2::params::web_root,
) {
  require ::icingaweb2

  validate_absolute_path($web_root)
  validate_re($install_method,
    [
      'git',
    ]
  )

  validate_re($datasource,
    [
      'influxdb',
      'graphite',
      'pnp',
    ]
  )

  validate_string($host)
  validate_string($defaultdashboard)

  File {
    require => Class['::icingaweb2::config'],
    owner   => $::icingaweb2::config_user,
    group   => $::icingaweb2::config_group,
    mode    => $::icingaweb2::config_file_mode,
  }

  file {
    "${web_root}/modules/grafana":
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;

    "${::icingaweb2::config_dir}/modules/grafana":
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;
  }

  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/modules/grafana"],
    path    => "${::icingaweb2::config_dir}/modules/grafana/config.ini",
  }

  ini_setting { 'host':
    section => 'grafana',
    setting => 'host',
    value   => $host,
  }

  ini_setting { 'datasource':
    section => 'grafana',
    setting => 'datasource',
    value   => $datasource,
  }

  ini_setting { 'defaultdashboard':
    section => 'grafana',
    setting => 'defaultdashboard',
    value   => $defaultdashboard,
  }

  if $username {
    ini_setting { 'username':
      section => 'grafana',
      setting => 'username',
      value   => $username,
    }
  }

  if $password {
    ini_setting { 'password':
      section => 'grafana',
      setting => 'password',
      value   => $password,
    }
  }

  if $protocol {
    ini_setting { 'protocol':
      section => 'grafana',
      setting => 'protocol',
      value   => $protocol,
    }
  }

  if $graph_height {
    ini_setting { 'graph_height':
      section => 'grafana',
      setting => 'graph_height',
      value   => $graph_height,
    }
  }

  if $graph_width {
    ini_setting { 'graph_width':
      section => 'grafana',
      setting => 'graph_width',
      value   => $graph_width,
    }
  }

  if $timerange {
    ini_setting { 'timerange':
      section => 'grafana',
      setting => 'timerange',
      value   => $timerange,
    }
  }

  if $enable_link {
    ini_setting { 'enable_link':
      section => 'grafana',
      setting => 'enableLink',
      value   => $enable_link,
    }
  }

  if $defaultdashboardstore {
    ini_setting { 'defaultdashboardstore':
      section => 'grafana',
      setting => 'defaultdashboardstore',
      value   => $defaultdashboardstore,
    }
  }

  if $accessmode {
    ini_setting { 'accessmode':
      section => 'grafana',
      setting => 'accessmode',
      value   => $accessmode,
    }
  }

  if $timeout {
    ini_setting { 'timeout':
      section => 'grafana',
      setting => 'timeout',
      value   => $timeout,
    }
  }

  if $directrefresh {
    ini_setting { 'directrefresh':
      section => 'grafana',
      setting => 'directrefresh',
      value   => $directrefresh,
    }
  }

  file { "${::icingaweb2::config_dir}/enabledModules/grafana":
    ensure => link,
    target => '/usr/share/icingaweb2/modules/grafana'
  }

  if $install_method == 'git' {
    if $pkg_deps {
      package { $pkg_deps:
        ensure => $pkg_ensure,
        before => Vcsrepo['grafana'],
      }
    }

    vcsrepo { 'grafana':
      ensure   => latest,
      path     => "${web_root}/modules/grafana",
      provider => 'git',
      revision => $git_revision,
      source   => $git_repo,
    }
  }
}
