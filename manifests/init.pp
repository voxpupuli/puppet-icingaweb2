# == Class icingaweb2
#
# $admin_permissions::
#                         Default:
#
# $admin_users::
#                         Default:
#
# $auth_backend::
#                         Default:
#
# $auth_resource::
#                         Default:
#
# $config_dir::           Location of the main configuration directory.
#                         Default: operating system specific.
#
# $config_dir_mode::      Posix file mode for configuration directories.
#                         Default: 0755.
#
# $config_dir_recurse::   Apply the same posix permissions as $config_dir to any
#                         directory contained in $config_dir.
#                         Default: false.
#
# $config_file_mode::     Posix file mode for configuration files.
#                         Default: 0644.
#
# $config_group::         Posix group for configuration files.
#                         Default: operating system specific.
#
# $config_user::          Posix user for configuration files.
#                         Default: operating system specific.
#
# $git_repo::             Source repository containing upstream IcingaWeb2.
#                         Default: 'https://git.icinga.org/icingaWeb2.git'
#
# $git_revision::         Allows git revisions, tags, hashes, ... to be
#                         specified.
#                         Default: undef.
#
# $ido_db::
#                         Default:
#
# $ido_db_host::
#                         Default:
#
# $ido_db_host::
#                         Default:
#
# $ido_db_name::
#                         Default:
#
# $ido_db_pass::
#                         Default:
#
# $ido_db_port::
#                         Default:
#
# $ido_db_user::
#                         Default:
#
# $ido_type::
#                         Default:
#
# $install_method::       Defines how to install install IcingaWeb2.
#                         Options: git, package
#                         Default: git.
#
# $log_application::
#                         Default:
#
# $log_level::
#                         Default:
#
# $log_method::
#                         Default:
#
# $log_resource::
#                         Default:
#
# $log_store::
#                         Default:
#
# $manage_apache_vhost::  Define wether or not this module should manage
#                         the virtualhost using Puppetlabs' apache module.
#                         Default: false.
#
# $manage_repo::          Add a custom package repository.
#                         Default: false.
#
# $pkg_deps::             Any dependencies that need to be resolved before
#                         installing the main package.
#                         Default: operating system specific.
#
# $pkg_ensure::           Ensure state for packages.
#                         Default: present.
#
# $pkg_list::             An array containing the main package and possibly
#                         a number of dependencies.
#                         Default: operating system specific.
#
# $pkg_repo_version::
#                         Options: release, snapshot.
#                         Default: release.
#
# $pkg_repo_release_key::
#                         Default: operating system specific.
#
# $pkg_repo_release_metadata_expire::
#                         Default: operating system specific.
#
# $pkg_repo_release_url::
#                         Default: operating system specific.
#
# $pkg_repo_snapshot_key::
#                         Default: operating system specific.
#
# $pkg_repo_snapshot_metadata_expire::
#                         Default: operating system specific.
#
# $pkg_repo_snapshot_url::
#                         Default: operating system specific.
#
# $template_auth::
#                         Default: icingaweb2/authentication.ini.erb
#
# $template_config::
#                         Default: icingaweb2/config.ini.erb
#
# $template_resources::
#                         Default: icingaweb2/resources.ini.erb
#
# $template_roles::
#                         Default: icingaweb2/roles.ini.erb
#
# $template_apache::
#                         Default: icingaweb2/apache2.ini.erb
#
# $web_db::
#                         Default:
#
# $web_db_host::
#                         Default:
#
# $web_db_name::
#                         Default:
#
# $web_db_pass::
#                         Default:
#
# $web_db_port::
#                         Default:
#
# $web_db_prefix::
#                         Default:
#
# $web_db_user::
#                         Default:
#
# $web_root::             Default location for when using using git.
#                         Default: operating system specific.
#
# $web_type::
#                         Default:
#
class icingaweb2 (
  $admin_permissions                 = $::icingaweb2::params::admin_permissions,
  $admin_users                       = $::icingaweb2::params::admin_users,
  $auth_backend                      = $::icingaweb2::params::auth_backend,
  $auth_resource                     = $::icingaweb2::params::auth_resource,
  $config_dir                        = $::icingaweb2::params::config_dir,
  $config_dir_mode                   = $::icingaweb2::params::config_dir_mode,
  $config_dir_recurse                = $::icingaweb2::params::config_dir_recurse,
  $config_file_mode                  = $::icingaweb2::params::config_file_mode,
  $config_group                      = $::icingaweb2::params::config_group,
  $config_user                       = $::icingaweb2::params::config_user,
  $git_repo                          = $::icingaweb2::params::git_repo,
  $git_revision                      = $::icingaweb2::params::git_revision,
  $ido_db                            = $::icingaweb2::params::ido_db,
  $ido_db_host                       = $::icingaweb2::params::ido_db_host,
  $ido_db_host                       = $::icingaweb2::params::ido_db_host,
  $ido_db_name                       = $::icingaweb2::params::ido_db_name,
  $ido_db_pass                       = $::icingaweb2::params::ido_db_pass,
  $ido_db_port                       = $::icingaweb2::params::ido_db_port,
  $ido_db_user                       = $::icingaweb2::params::ido_db_user,
  $ido_type                          = $::icingaweb2::params::ido_type,
  $install_method                    = $::icingaweb2::params::install_method,
  $log_application                   = $::icingaweb2::params::log_application,
  $log_level                         = $::icingaweb2::params::log_level,
  $log_method                        = $::icingaweb2::params::log_method,
  $log_resource                      = $::icingaweb2::params::log_resource,
  $log_store                         = $::icingaweb2::params::log_store,
  $manage_apache_vhost               = $::icingaweb2::params::manage_apache_vhost,
  $manage_repo                       = $::icingaweb2::params::manage_repo,
  $pkg_deps                          = $::icingaweb2::params::pkg_deps,
  $pkg_ensure                        = $::icingaweb2::params::pkg_ensure,
  $pkg_list                          = $::icingaweb2::params::pkg_list,
  $pkg_repo_release_key              = $::icingaweb2::params::pkg_repo_release_key,
  $pkg_repo_release_metadata_expire  = $::icingaweb2::params::pkg_repo_release_metadata_expire,
  $pkg_repo_release_url              = $::icingaweb2::params::pkg_repo_release_url,
  $pkg_repo_snapshot_key             = $::icingaweb2::params::pkg_repo_snapshot_key,
  $pkg_repo_snapshot_metadata_expire = $::icingaweb2::params::pkg_repo_snapshot_metadata_expire,
  $pkg_repo_snapshot_url             = $::icingaweb2::params::pkg_repo_snapshot_url,
  $pkg_repo_version                  = $::icingaweb2::params::pkg_repo_version,
  $template_auth                     = $::icingaweb2::params::template_auth,
  $template_config                   = $::icingaweb2::params::template_config,
  $template_resources                = $::icingaweb2::params::template_resources,
  $template_roles                    = $::icingaweb2::params::template_roles,
  $template_apache                   = $::icingaweb2::params::template_apache,
  $web_db                            = $::icingaweb2::params::web_db,
  $web_db_host                       = $::icingaweb2::params::web_db_host,
  $web_db_name                       = $::icingaweb2::params::web_db_name,
  $web_db_pass                       = $::icingaweb2::params::web_db_pass,
  $web_db_port                       = $::icingaweb2::params::web_db_port,
  $web_db_prefix                     = $::icingaweb2::params::web_db_prefix,
  $web_db_user                       = $::icingaweb2::params::web_db_user,
  $web_root                          = $::icingaweb2::params::web_root,
  $web_type                          = $::icingaweb2::params::web_type,
) inherits ::icingaweb2::params {
  class { '::icingaweb2::preinstall': } ->
  class { '::icingaweb2::install': } ->
  class { '::icingaweb2::config': } ->
  Class['::icingaweb2']

  validate_absolute_path($config_dir)
  validate_absolute_path($web_root)
  validate_array($pkg_deps)
  validate_array($pkg_list)
  validate_bool($config_dir_recurse)
  validate_bool($manage_repo)
  validate_slength($config_dir_mode, 4)
  validate_slength($config_file_mode, 4)
  validate_string($admin_permissions)
  validate_string($admin_users)
  validate_string($auth_backend)
  validate_string($auth_resource)
  validate_string($config_dir_mode)
  validate_string($config_file_mode)
  validate_string($config_group)
  validate_string($config_user)
  validate_string($log_application)
  validate_string($log_level)
  validate_string($log_method)
  validate_string($log_resource)
  validate_string($log_store)
  validate_string($pkg_ensure)
  validate_string($pkg_repo_release_key)
  validate_string($pkg_repo_release_url)
  validate_string($pkg_repo_snapshot_key)
  validate_string($pkg_repo_snapshot_url)
  validate_string($template_auth)
  validate_string($template_config)
  validate_string($template_resources)
  validate_string($template_roles)

  if $::icingaweb2::manage_apache_vhost {
    validate_string($template_apache)
  }

  if $pkg_repo_release_metadata_expire {
    validate_string($pkg_repo_release_metadata_expire)
  }

  if $pkg_repo_snapshot_metadata_expire {
    validate_string($pkg_repo_snapshot_metadata_expire)
  }

  validate_re($install_method,
    [
      'git',
      'package',
    ]
  )

  validate_re($pkg_ensure,
    [
      'absent',
      'latest',
      'present',
      'purged',
    ]
  )

  validate_re($pkg_repo_version,
    [
      'release',
      'snapshot',
    ]
  )
}

