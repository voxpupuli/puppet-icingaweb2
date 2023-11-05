# @summary
#   Install the reporting module.
#
# @api private
#
class icingaweb2::module::reporting::install {
  assert_private()

  $module_conf_dir = "${icingaweb2::globals::conf_dir}/modules/reporting"
  $conf_user       = $icingaweb2::conf_user
  $conf_group      = $icingaweb2::conf_group
  $ensure          = $icingaweb2::module::reporting::ensure
  $git_repository  = $icingaweb2::module::reporting::git_repository
  $git_revision    = $icingaweb2::module::reporting::git_revision
  $install_method  = $icingaweb2::module::reporting::install_method
  $module_dir      = $icingaweb2::module::reporting::module_dir
  $package_name    = $icingaweb2::module::reporting::package_name
  $use_tls         = $icingaweb2::module::reporting::use_tls
  $tls             = $icingaweb2::module::reporting::tls
  $cert_dir        = $icingaweb2::module::reporting::cert_dir
  $service_user    = $icingaweb2::module::reporting::service_user
  $mail            = $icingaweb2::module::reporting::mail

  icingaweb2::module { 'reporting':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
    settings       => {
      'icingaweb2-module-reporting-backend' => {
        'section_name' => 'backend',
        'target'       => "${module_conf_dir}/config.ini",
        'settings'     => {
          'resource' => 'reporting',
        },
      },
      'icingaweb2-module-reporting-mail'    => {
        'section_name' => 'mail',
        'target'       => "${module_conf_dir}/config.ini",
        'settings'     => delete_undef_values({
            'from' => $mail,
        }),
      },
    },
  }

  if $use_tls {
    file { $cert_dir:
      ensure => directory,
      owner  => 'root',
      group  => $conf_group,
      mode   => '2770',
    }

    icinga::cert { 'icingaweb2::module::reporting tls client config':
      owner => $conf_user,
      group => $conf_group,
      args  => $tls,
    }
  }

  if $install_method == 'git' {
    user { $service_user:
      ensure => 'present',
      gid    => $conf_group,
      shell  => '/bin/false',
    }
  }
}
