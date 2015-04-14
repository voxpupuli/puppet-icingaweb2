# == Class icingaweb2::config
#
class icingaweb2::config {

  if( is_function_available('assert_private') ) {
    assert_private()
  } else {
    private()
  }

  @user {
    'icingaweb2':
      ensure     => present,
      home       => $::icingaweb2::web_root,
      managehome => true,
  }

  @group {
    'icingaweb2':
      ensure => present,
      system => true,
  }

  realize(User['icingaweb2'])
  realize(Group['icingaweb2'])

  File {
    owner   => $::icingaweb2::config_user,
    group   => $::icingaweb2::config_group,
    mode    => $::icingaweb2::config_file_mode,
    require => Class['::icingaweb2::install']
  }

  file {
    $::icingaweb2::web_root:
      ensure => directory,
      mode   => $::icingaweb2::config_dir_mode
  }

  file {[
    "${::icingaweb2::config_dir}",
    "${::icingaweb2::config_dir}/enabledModules",
    "${::icingaweb2::config_dir}/modules",
    "${::icingaweb2::config_dir}/modules/monitoring"]:
      ensure  => directory,
      mode    => $::icingaweb2::config_dir_mode,
      recurse => $::icingaweb2::config_dir_recurse
  }

  concat {
    "icingaweb2_config":
      path      => "${::icingaweb2::config_dir}/config.ini",
      mode      => '0644'
  }

  concat {
    "icingaweb2_authentication":
      path      => "${::icingaweb2::config_dir}/authentication.ini",
      mode      => '0644'
  }

  concat {
    "icingaweb2_resources":
      path      => "${::icingaweb2::config_dir}/resources.ini",
      mode      => '0644'
  }

  file {[
    "${::icingaweb2::config_dir}/roles.ini"]:
      ensure => file
  }

  concat::fragment {
    "icingaweb2_config_CONTENT":
      target  => "icingaweb2_config",
      content => template( 'icingaweb2/config.ini.erb' ),
      order   => 10
  }


  # enable / disable modules
  icingaweb2::modules {
    'enable modules':
      enabled  => $::icingaweb2::modules_enabled,
      disabled => $::icingaweb2::modules_disabled,
      require  => File["${::icingaweb2::config_dir}/modules/monitoring"]
  }

  # Configure roles.ini
  icingaweb2::config::roles {
    'Admins':
      role_users       => $::icingaweb2::admin_users,
      role_permissions => $::icingaweb2::admin_permissions,
  }

  if( $::icingaweb2::manage_apache_vhost ) {

    ::apache::custom_config {
      'icingaweb2':
        content => template($::icingaweb2::template_apache),
    }
  }
}

