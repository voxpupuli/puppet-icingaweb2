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
  Enum['absent', 'present'] $ensure = 'present',
){
  icingaweb2::module { 'doc':
    ensure         => $ensure,
    install_method => 'none',
  }
}
