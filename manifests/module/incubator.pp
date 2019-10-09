# == Class: icingaweb2::module::incubator
#
# Install and enable the incubator module.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
# [*git_repository*]
#   Set a git repository URL. Defaults to github.
#
# [*git_revision*]
#   Set either a branch or a tag name, eg. `stable/0.7.0` or `v0.7.0`.
#
class icingaweb2::module::incubator(
  Enum['absent', 'present'] $ensure         = 'present',
  String                    $git_repository = 'https://github.com/Icinga/icingaweb2-module-incubator.git',
  String                    $git_revision   = undef,
){

  icingaweb2::module { 'incubator':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }

}
