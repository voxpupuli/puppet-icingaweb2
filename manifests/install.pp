# @summary
#   Installs Icinga Web 2 and extra packages.
#
# @api private
#
class icingaweb2::install {
  assert_private("You're not supposed to use this defined type manually.")

  $conf_dir       = $icingaweb2::globals::conf_dir
  $state_dir      = $icingaweb2::globals::state_dir
  $package_name   = $icingaweb2::globals::package_name
  $data_dir       = $icingaweb2::globals::data_dir
  $comp_dir       = $icingaweb2::globals::comp_db_schema_dir
  $manage_package = $icingaweb2::manage_package
  $extra_packages = $icingaweb2::extra_packages
  $conf_group     = $icingaweb2::conf_group

  #
  # Packages
  #
  if $manage_package {
    package { $package_name:
      ensure => installed,
    }
  }

  if $extra_packages {
    $metadata = load_module_metadata('stdlib')
    if versioncmp($metadata['version'], '9.0.0') < 0 {
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
    "${state_dir}/certs":
      mode  => '2770',
      ;
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

  exec { 'link old db schema directory for compatibility':
    path    => $facts['path'],
    command => "ln -s ${data_dir}/schema ${comp_dir}/schema",
    unless  => "stat ${comp_dir}/schema",
  }
}
