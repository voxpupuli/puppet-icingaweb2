# @summary
#   Manage settings in INI configuration files.
#
# @param [Stdlib::Absolutepath] target
#   Absolute path to the configuration file.
#
# @param [String] section_name
#   Name of the target section. Settings are set under [$section_name]
#
# @param [Hash] settings
#   A hash of settings and their settings. Single settings may be set to absent.
#
# @param [Variant[String, Integer]] order
#   Ordering of the INI section within a file. Defaults to `01`
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
define icingaweb2::inisection(
  Stdlib::Absolutepath      $target,
  String                    $section_name  = $title,
  Hash                      $settings      = {},
  Variant[String, Integer]  $order         = '01',
){

  $conf_user      = $::icingaweb2::conf_user
  $conf_group     = $::icingaweb2::conf_group

  if !defined(Concat[$target]) {
    concat { $target:
      ensure => present,
      warn   => false,
      owner  => $conf_user,
      group  => $conf_group,
      mode   => '0640',
    }
  }

  concat::fragment { "${title}-${section_name}-${order}":
    target  =>  $target,
    content => template('icingaweb2/inisection.erb'),
    order   => $order,
  }
}
