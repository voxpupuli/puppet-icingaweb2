# == Class icingaweb2
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
# $web_root::             pending
#                         Default: operating system specific.
#
class icingaweb2 (
  $config_dir          = $::icingaweb2::params::config_dir,
  $config_dir_mode     = $::icingaweb2::params::config_dir_mode,
  $config_dir_recurse  = $::icingaweb2::params::config_dir_recurse,
  $config_file_mode    = $::icingaweb2::params::config_file_mode,
  $config_group        = $::icingaweb2::params::config_group,
  $config_user         = $::icingaweb2::params::config_user,
  $git_repo            = $::icingaweb2::params::git_repo,
  $git_revision        = $::icingaweb2::params::git_revision,
  $ido_db              = $::icingaweb2::params::ido_db,
  $ido_db_host         = $::icingaweb2::params::ido_db_host,
  $ido_db_host         = $::icingaweb2::params::ido_db_host,
  $ido_db_name         = $::icingaweb2::params::ido_db_name,
  $ido_db_pass         = $::icingaweb2::params::ido_db_pass,
  $ido_db_port         = $::icingaweb2::params::ido_db_port,
  $ido_db_user         = $::icingaweb2::params::ido_db_user,
  $ido_type            = $::icingaweb2::params::ido_type,
  $install_method      = $::icingaweb2::params::install_method,
  $manage_apache_vhost = $::icingaweb2::params::manage_apache_vhost,
  $manage_repo         = $::icingaweb2::params::manage_repo,
  $pkg_deps            = $::icingaweb2::params::pkg_deps,
  $pkg_ensure          = $::icingaweb2::params::pkg_ensure,
  $pkg_list            = $::icingaweb2::params::pkg_list,
  $web_db              = $::icingaweb2::params::web_db,
  $web_db_host         = $::icingaweb2::params::web_db_host,
  $web_db_name         = $::icingaweb2::params::web_db_name,
  $web_db_pass         = $::icingaweb2::params::web_db_pass,
  $web_db_port         = $::icingaweb2::params::web_db_port,
  $web_db_prefix       = $::icingaweb2::params::web_db_prefix,
  $web_db_user         = $::icingaweb2::params::web_db_user,
  $web_root            = $::icingaweb2::params::web_root,
  $web_type            = $::icingaweb2::params::web_type,
) inherits icingaweb2::params {
  class { 'icingaweb2::preinstall': } ->
  class { 'icingaweb2::install': } ->
  class { 'icingaweb2::config': } ->
  Class [ 'icingaweb2' ]

  validate_absolute_path($config_dir)
  validate_absolute_path($web_root)
  validate_array($pkg_deps)
  validate_array($pkg_list)
  validate_bool($config_dir_recurse)
  validate_bool($manage_repo)
  validate_slength($config_dir_mode, 4)
  validate_slength($config_file_mode, 4)
  validate_string($config_dir_mode)
  validate_string($config_file_mode)
  validate_string($config_group)
  validate_string($config_user)
  validate_string($pkg_ensure)

  validate_re($install_method,
    [
      'git',
      'package',
      'packages',
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
}

