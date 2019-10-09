# == Class: icingaweb2::module::reactbundle
#
# Install and enable the reactbundle module.
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
class icingaweb2::module::reactbundle(
  Enum['absent', 'present'] $ensure         = 'present',
  String                    $git_repository = 'https://github.com/Icinga/icingaweb2-module-reactbundle.git',
  String                    $git_revision   = undef,
){

  icingaweb2::module { 'reactbundle':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }

}

