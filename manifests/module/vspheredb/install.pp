# @summary
#   Install the VSphereDB module
#
# @api private
#
class icingaweb2::module::vspheredb::install {
  assert_private()

  $conf_user       = $icingaweb2::conf_user
  $conf_group      = $icingaweb2::conf_group
  $ensure          = $icingaweb2::module::vspheredb::ensure
  $git_repository  = $icingaweb2::module::vspheredb::git_repository
  $git_revision    = $icingaweb2::module::vspheredb::git_revision
  $install_method  = $icingaweb2::module::vspheredb::install_method
  $module_dir      = $icingaweb2::module::vspheredb::module_dir
  $package_name    = $icingaweb2::module::vspheredb::package_name
  $use_tls         = $icingaweb2::module::vspheredb::use_tls
  $tls             = $icingaweb2::module::vspheredb::tls
  $cert_dir        = $icingaweb2::module::vspheredb::cert_dir
  $service_user    = $icingaweb2::module::vspheredb::service_user

  icingaweb2::module { 'vspheredb':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
  }

  if $use_tls {
    file { $cert_dir:
      ensure => directory,
      owner  => 'root',
      group  => $conf_group,
      mode   => '2770',
    }

    icinga::cert { 'icingaweb2::module::vspheredb tls client config':
      owner => $conf_user,
      group => $conf_group,
      args  => $tls,
    }
  }

  if $install_method != 'none' {
    user { $service_user:
      ensure => 'present',
      gid    => $conf_group,
      shell  => '/bin/false',
      system => true,
    }
  }
}
