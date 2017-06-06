# == Define: icingaweb2::inifile
#
# Manage settings in INI configuration files.
#
# === Parameters
#
# [*ensure*]
#   Set to present creates the ini section, absent removes it. Defaults to present.
#   Single settings may be set to 'absent' in the $settings parameter.
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
  $ensure        = present,
  $section_name  = $title,
  $settings      = {},
){

  $conf_user      = $::icingaweb2::params::conf_user
  $conf_group     = $::icingaweb2::params::conf_group

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_string($section_name)
  validate_absolute_path($target)
  validate_hash($settings)

  ensure_resource('file', $target, {
    ensure => present,
    owner  => $conf_user,
    group  => $conf_group,
  })

  $defaults = {
    'ensure' => $ensure,
    'path'   => $target,
  }

  $section = { "${section_name}" => $settings }
  manage_ini_settings($section, $defaults)

  File <| |> -> Ini_setting <| |>
}