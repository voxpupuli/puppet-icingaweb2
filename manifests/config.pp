# == Class icingaweb2::config
#
class icingaweb2::config {
  @user { 'icingaweb2':
    ensure     => present,
    home       => $::icingaweb2::web_root,
    managehome => true,
  }

  @group { 'icingaweb2':
    ensure => present,
    system => true,
  }

  realize(User['icingaweb2'])
  realize(Group['icingaweb2'])

  File {
    require => Class['::icingaweb2::install'],
    owner   => $::icingaweb2::config_user,
    group   => $::icingaweb2::config_group,
    mode    => $::icingaweb2::config_file_mode,
  }

  file {
    $::icingaweb2::config_dir:
      ensure  => directory,
      mode    => $::icingaweb2::config_dir_mode,
      recurse => $::icingaweb2::config_dir_recurse;

    "${::icingaweb2::config_dir}/enabledModules":
      ensure  => directory;

    "${::icingaweb2::config_dir}/modules":
      ensure  => directory;

    "${::icingaweb2::config_dir}/authentication.ini":
      ensure  => present,
      content => template('icingaweb2/authentication.ini.erb');

    "${::icingaweb2::config_dir}/config.ini":
      ensure  => present,
      content => template('icingaweb2/config.ini.erb');

    "${::icingaweb2::config_dir}/resources.ini":
      ensure  => present,
      content => template('icingaweb2/resources.ini.erb');

    "${::icingaweb2::config_dir}/roles.ini":
      ensure  => present,
      content => template('icingaweb2/roles.ini.erb');

    $::icingaweb2::web_root:
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;
  }
}

