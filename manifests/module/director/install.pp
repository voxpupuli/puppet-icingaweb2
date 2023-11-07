# @summary
#   Install the director module.
#
# @api private
#
class icingaweb2::module::director::install {
  assert_private()

  $stdlib_version  = $icingaweb2::globals::stdlib_version
  $conf_user       = $icingaweb2::conf_user
  $conf_group      = $icingaweb2::conf_group
  $ensure          = $icingaweb2::module::director::ensure
  $cert_dir        = $icingaweb2::module::director::cert_dir
  $git_repository  = $icingaweb2::module::director::git_repository
  $git_revision    = $icingaweb2::module::director::git_revision
  $install_method  = $icingaweb2::module::director::install_method
  $import_schema   = $icingaweb2::module::director::import_schema
  $module_dir      = $icingaweb2::module::director::module_dir
  $package_name    = $icingaweb2::module::director::package_name
  $use_tls         = $icingaweb2::module::director::use_tls
  $tls             = $icingaweb2::module::director::tls
  $service_user    = $icingaweb2::module::director::service_user

  icingaweb2::module { 'director':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
  }

  if $install_method == 'git' {
    user { $service_user:
      ensure => present,
      gid    => $conf_group,
      shell  => '/bin/false',
    }
  }

  if $use_tls {
    file { $cert_dir:
      ensure => directory,
      owner  => 'root',
      group  => $conf_group,
      mode   => '2770',
    }

    icinga::cert { 'icingaweb2::module::director tls client config':
      owner => $conf_user,
      group => $conf_group,
      args  => $tls,
    }
  }

  if $import_schema {
    if versioncmp($stdlib_version, '9.0.0') < 0 {
      ensure_packages(['icingacli'], { 'ensure' => 'present' })
    } else {
      stdlib::ensure_packages(['icingacli'], { 'ensure' => 'present' })
    }
  }
}
