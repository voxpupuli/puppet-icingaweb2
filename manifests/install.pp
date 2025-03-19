# @summary
#   Installs Icinga Web 2 and extra packages.
#
# @api private
#
class icingaweb2::install {
  assert_private("You're not supposed to use this defined type manually.")

  $conf_dir       = $icingaweb2::globals::conf_dir
  $stdlib_version = $icingaweb2::globals::stdlib_version
  $cert_dir       = $icingaweb2::cert_dir
  $package_name   = $icingaweb2::globals::package_name
  $data_dir       = $icingaweb2::globals::data_dir
  $comp_dir       = $icingaweb2::globals::comp_db_schema_dir
  $manage_package = $icingaweb2::manage_package
  $extra_packages = $icingaweb2::extra_packages
  $conf_user      = $icingaweb2::conf_user
  $conf_group     = $icingaweb2::conf_group
  $use_tls        = $icingaweb2::use_tls
  $tls            = $icingaweb2::tls

  #
  # Packages
  #
  if $manage_package {
    package { $package_name:
      ensure => installed,
    }
    File {
      require => Package[$package_name],
    }
  }

  if $extra_packages {
    if versioncmp($stdlib_version, '9.0.0') < 0 {
      ensure_packages($extra_packages, { 'ensure' => installed })
    } else {
      stdlib::ensure_packages($extra_packages, { 'ensure' => installed })
    }
  }

  #
  # Additional filesystem structure
  #
  file {
    default:
      ensure => directory,
      owner  => root,
      group  => $conf_group,
      ;
    prefix(['modules', 'enabledModules', 'navigation', 'preferences', 'dashboards'], "${conf_dir}/"):
      mode => '2770',
      ;
    $cert_dir:
      mode => '2770',
      ;
  }

  if $use_tls {
    icinga::cert { 'icingaweb2 tls client config':
      owner => $conf_user,
      group => $conf_group,
      args  => $tls,
    }
  }

  #
  # Compatmode: db schema files were moved in Icinga Web 2.11.0
  #
  file { $comp_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  -> exec { 'link old db schema directory for compatibility':
    path    => $facts['path'],
    command => "ln -s ${data_dir}/schema ${comp_dir}/schema",
    unless  => "stat ${comp_dir}/schema",
  }
}
