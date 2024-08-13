# @summary
#   Manage settings in INI configuration files.
#
# @param target
#   Absolute path to the configuration file.
#
# @param section_name
#   Name of the target section. Settings are set under [$section_name]
#
# @param settings
#   A hash of settings and their settings. Single settings may be set to absent.
#
# @param order
#   Ordering of the INI section within a file. Defaults to `01`
#
# @param replace
#   Specifies whether to overwrite the destination file if it already exists.
#
# @example Create the configuration file and set two settings for the section `global`:
#   include icingawebeb2
#
#   icingaweb2::inisection { '/path/to/config.ini':
#     settings => {
#       'global' => {
#         'setting1' => 'value',
#         'setting2' => 'value',
#       },
#     },
#   }
#
define icingaweb2::inisection (
  Stdlib::Absolutepath            $target,
  String[1]                       $section_name  = $title,
  Hash                            $settings      = {},
  Variant[String[1], Integer[1]]  $order         = '01',
  Boolean                         $replace       = true,
) {
  $conf_user      = $icingaweb2::conf_user
  $conf_group     = $icingaweb2::conf_group

  if !defined(Concat[$target]) {
    concat { $target:
      ensure  => present,
      warn    => false,
      replace => $replace,
      owner   => $conf_user,
      group   => $conf_group,
      mode    => '0640',
    }
  }

  concat::fragment { "${title}-${section_name}-${order}":
    target  => $target,
    content => template('icingaweb2/inisection.erb'),
    order   => $order,
  }
}
