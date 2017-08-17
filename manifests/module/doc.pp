# == Define: icingaweb2::module::doc
#
# Install and configure the doc module.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
class icingaweb2::module::doc(
  $ensure        = 'present',
){
  $module_dir = "${::icingaweb2::params::module_path}/doc"

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")

  icingaweb2::module { 'doc':
    ensure         => $ensure,
    module_dir     => $module_dir,
    install_method => 'none',
  }
}
