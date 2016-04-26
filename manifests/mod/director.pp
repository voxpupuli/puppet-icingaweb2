# == Class icingaweb2::mod::director
#
class icingaweb2::mod::director (
  $git_repo       = 'https://github.com/Icinga/icingaweb2-module-director.git',
  $git_revision   = undef,
  $install_method = 'git',
  $pkg_deps       = undef,
  $pkg_ensure     = 'present',
  $web_root       = $::icingaweb2::params::web_root,
  $db_resource    = undef,
  $endpoint_name = undef,
  $endpoint_host = undef,
  $endpoint_port = undef,
  $endpoint_username = undef,
  $endpoint_password = undef,
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
  
  file { "${::icingaweb2::config_dir}/modules/director":
    ensure => directory,
    mode   => $::icingaweb2::config_dir_mode;
  }

  $director_mod_files = [
    "${::icingaweb2::config_dir}/modules/director/config.ini",
    "${::icingaweb2::config_dir}/modules/director/kickstart.ini",
  ]

  file { $director_mod_files:
    ensure => present,
  }

  if $install_method == 'git' {
    if $pkg_deps {
      package { $pkg_deps:
        ensure => $pkg_ensure,
        before => Vcsrepo['director'],
      }
    }

    vcsrepo { 'director':
      ensure   => present,
      path     => "${web_root}/modules/director",
      provider => 'git',
      revision => $git_revision,
      source   => $git_repo,
    }
  }
  file { "${::icingaweb2::config_dir}/enabledModules/director":
    ensure  => link,
    target  => '/usr/share/icingaweb2/modules/director',
    require => Vcsrepo['director'],
  }

  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/modules/director"],
  }

  ini_setting { 'director db resource':
    section => 'db',
    setting => 'resource',
    value   => $db_resource,
    path    => "${::icingaweb2::config_dir}/modules/director/config.ini",
  }
  
  ini_setting { 'director kickstart endpoint name':
    section => 'config',
    setting => 'endpoint',
    value   => $endpoint_name,
    path    => "${::icingaweb2::config_dir}/modules/director/kickstart.ini",
  }
  ini_setting { 'director kickstart endpoint host':
    section => 'config',
    setting => 'host',
    value   => $endpoint_host,
    path    => "${::icingaweb2::config_dir}/modules/director/kickstart.ini",
  }
  ini_setting { 'director kickstart endpoint port':
    section => 'config',
    setting => 'port',
    value   => $endpoint_port,
    path    => "${::icingaweb2::config_dir}/modules/director/kickstart.ini",
  }
  ini_setting { 'director kickstart endpoint username':
    section => 'config',
    setting => 'username',
    value   => $endpoint_username,
    path    => "${::icingaweb2::config_dir}/modules/director/kickstart.ini",
  }
  ini_setting { 'director kickstart endpoint password':
    section => 'config',
    setting => 'password',
    value   => $endpoint_password,
    path    => "${::icingaweb2::config_dir}/modules/director/kickstart.ini",
  }

  exec { 'Icinga Director DB migration':
    path    => '/usr/local/bin:/usr/bin:/bin',
    command => 'icingacli director migration run',
    onlyif  => 'icingacli director migration pending',
  }

  exec { 'Icinga Director Kickstart':
    path    => '/usr/local/bin:/usr/bin:/bin',
    command => 'icingacli director kickstart run',
    onlyif  => 'icingacli director kickstart required',
    require => Exec['Icinga Director DB migration'],
  }
}
