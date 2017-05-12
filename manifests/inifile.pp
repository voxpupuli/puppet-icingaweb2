# == Define: icingaweb2::inifile
#
# Manage settings in INI configuration files.
#
# === Parameters
#
# [*ensure*]
#   Set to present creates the configuration file, absent removes it. Defaults to present.
#   Singhe settings may be set to 'absent' int he $settings parameter.
#
# [*target*]
#   Absolute path to the configuration file.
#
# [*settings*]
#   A hash of settings and their settings. Single settings may be set to absent.
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
define icingaweb2::inifile(
  $ensure   = present,
  $target   = $title,
  $settings = {},
){

  $conf_user      = $::icingaweb2::params::conf_user
  $conf_group     = $::icingaweb2::params::conf_group

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($target)
  validate_hash($settings)

  if $ensure == 'present' {
    file { $target:
      owner => $conf_user,
      group => $conf_group
    }

    $defaults = { 'path' => $target }
    create_ini_settings($settings, $defaults)
  } else {
    file { $target:
      ensure => $ensure,
    }
  }
}