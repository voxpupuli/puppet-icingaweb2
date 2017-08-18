# == Class: icingaweb2::module::doc
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

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")

  icingaweb2::module { 'doc':
    ensure         => $ensure,
    install_method => 'none',
  }
}
