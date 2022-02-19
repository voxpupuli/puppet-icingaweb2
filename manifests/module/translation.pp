# @summary
#   Installs and configures the translation module.
#
# @param ensure
#   Enable or disable module.
#
class icingaweb2::module::translation(
  Enum['absent', 'present'] $ensure = 'present',
) {

  $conf_dir             = $::icingaweb2::globals::conf_dir
  $gettext_package_name = $icingaweb2::globals::gettext_package_name
  $module_conf_dir      = "${conf_dir}/modules/translation"

  # gettext-tools SUSE
  package { $gettext_package_name:
    ensure => $ensure,
  }

  $settings = {
    'module-translation' => {
      'section_name' => 'translation',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => {
        'msgmerge' => '/usr/bin/msgmerge',
        'xgettext' => '/usr/bin/xgettext',
        'msgfmt'   => '/usr/bin/msgfmt',
      },
    },
  }

  icingaweb2::module { 'translation':
    ensure         => $ensure,
    install_method => 'none',
    settings       => $settings,
  }

}
