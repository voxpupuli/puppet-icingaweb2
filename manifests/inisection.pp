# == Define: icingaweb2::inifile
#
# Manage settings in INI configuration files.
#
# === Parameters
#
# [*section_name*]
#   Name of the target section. Settings are set under [$section_name]
#
# [*target*]
#   Absolute path to the configuration file.
#
# [*settings*]
#   A hash of settings and their settings. Single settings may be set to absent.
#
# [*order*]
#   Ordering of the INI section within a file. Defaults to `01`
#
# === Examples
#
# Create the configuration file '/path/to/config.ini' and set the settings 'setting1' and 'setting2' for the section
# 'global'
#
# include icingawebeb2
# icingaweb2::inifile {"/path/to/config.ini":
#   settings => {
#     'global' => {
#       'setting1' => 'value',
#       'setting2' => 'value',
#     },
#   },
# }
#
define icingaweb2::inisection(
  $target,
  $section_name  = $title,
  $settings      = {},
  $order         = '01',
){

  $conf_user      = $::icingaweb2::params::conf_user
  $conf_group     = $::icingaweb2::params::conf_group

  validate_string($section_name)
  validate_absolute_path($target)
  validate_hash($settings)
  validate_string($order)

  if !defined(Concat[$target]) {
    concat { $target:
      ensure => present,
      warn   => false,
      owner  => $conf_user,
      group  => $conf_group,
    }
  }

  concat::fragment { $section_name:
    target  =>  $target,
    content => template('icingaweb2/inisection.erb'),
    order   => $order,
  }
}