# @summary
#   Install the x509 module
#
class icingaweb2::module::x509::install {
  assert_private()

  $conf_user       = $icingaweb2::conf_user
  $conf_group      = $icingaweb2::conf_group
  $module_dir      = $icingaweb2::module::x509::module_dir
  $cert_dir        = $icingaweb2::module::x509::cert_dir
  $ensure          = $icingaweb2::module::x509::ensure
  $git_repository  = $icingaweb2::module::x509::git_repository
  $git_revision    = $icingaweb2::module::x509::git_revision
  $install_method  = $icingaweb2::module::x509::install_method
  $package_name    = $icingaweb2::module::x509::package_name
  $use_tls         = $icingaweb2::module::x509::use_tls
  $tls             = $icingaweb2::module::x509::tls
  $service_user    = $icingaweb2::module::x509::service_user

  icingaweb2::module { 'x509':
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

    icinga::cert { 'icingaweb2::module::x509 tls client config':
      owner => $conf_user,
      group => $conf_group,
      args  => $tls,
    }
  }
}
