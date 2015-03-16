# == Class icingaweb2::config
#
class icingaweb2::config {
  assert_private()

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
    owner => $::icingaweb2::config_user,
    group => $::icingaweb2::config_group,
    mode  => $::icingaweb2::config_file_mode,
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
      content => template("${::icingaweb2::template_auth}");

    "${::icingaweb2::config_dir}/config.ini":
      ensure  => present,
      content => template("${::icingaweb2::template_config}");

    "${::icingaweb2::config_dir}/resources.ini":
      ensure  => present,
      content => template("${::icingaweb2::template_resources}");

    "${::icingaweb2::config_dir}/roles.ini":
      ensure  => present,
      content => template("${::icingaweb2::template_roles}");

    $::icingaweb2::web_root:
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode;
  }

  if $::icingaweb2::manage_apache_vhost {
    ::apache::custom_config { 'icingaweb2':
      content => template("${::icingaweb2::template_apache}"),
    }
  }
}

