# @summary
#   The Graphite module draws graphs out of time series data stored in Graphite.
#
# @note If you want to use `git` as `install_method`, the CLI `git` command has to be installed. You can manage it yourself as package resource or declare the package name in icingaweb2 class parameter `extra_packages`.
#
# @param ensure
#   Enables or disables module.
#
# @param module_dir
#   Target directory of the module.
#
# @param git_repository
#   Set a git repository URL.
#
# @param git_revision
#   Set either a branch or a tag name, eg. `master` or `v1.3.2`.   
#
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param url
#   URL to your Graphite Web/API.
#
# @param insecure
#   Do not verify the TLS certificate.
#
# @param user
#   A user with access to your Graphite Web via HTTP basic authentication.
#
# @param password
#   The users password.
#
# @param graphite_writer_host_name_template
#    The value of your Icinga 2 GraphiteWriter's attribute `host_name_template` (if specified).
#
# @param graphite_writer_service_name_template
#   The value of your icinga 2 GraphiteWriter's attribute `service_name_template` (if specified).
#
# @param customvar_obscured_check_command
#   The Icinga custom variable with the `actual` check command obscured by e.g. check_by_ssh.
#
# @param default_time_range_unit
#   Set unit for the time range.
#
# @param default_time_range
#   Set the displayed time range.
#
# @param disable_no_graphs
#   Do not display empty graphs.
#
# @note Here the official [Graphite module documentation](https://www.icinga.com/docs/graphite/latest/) can be found.
#
# @example
#   class { 'icingaweb2::module::graphite':
#     git_revision => 'v0.9.0',
#     url          => 'https://localhost:8080'
#   }
#
class icingaweb2::module::graphite (
  Enum['absent', 'present']         $ensure,
  Stdlib::HTTPUrl                   $git_repository,
  Enum['git', 'none', 'package']    $install_method,
  String[1]                         $package_name,
  Stdlib::Absolutepath              $module_dir                            = "${icingaweb2::globals::default_module_path}/graphite",
  Optional[String[1]]               $git_revision                          = undef,
  Optional[Stdlib::HTTPUrl]         $url                                   = undef,
  Optional[Boolean]                 $insecure                              = undef,
  Optional[String[1]]               $user                                  = undef,
  Optional[Icinga::Secret]          $password                              = undef,
  Optional[Icingaweb2::Secret]      $password                              = undef,
  Optional[String[1]]               $graphite_writer_host_name_template    = undef,
  Optional[String[1]]               $graphite_writer_service_name_template = undef,
  Optional[String[1]]               $customvar_obscured_check_command      = undef,
  Optional[Enum[
      'minutes', 'hours', 'days',
      'weeks', 'months', 'years'
  ]]                                $default_time_range_unit               = undef,
  Optional[Integer[1]]              $default_time_range                    = undef,
  Optional[Boolean]                 $disable_no_graphs                     = undef,
) {
  require icingaweb2

  $conf_dir        = $icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/graphite"

  $graphite_settings = {
    'url'      => $url,
    'user'     => $user,
    'password' => unwrap($password),
    'insecure' => $insecure,
  }

  $icinga_settings = {
    'graphite_writer_host_name_template'    => $graphite_writer_host_name_template,
    'graphite_writer_service_name_template' => $graphite_writer_service_name_template,
    'customvar_obscured_check_command'      => $customvar_obscured_check_command,
  }

  $ui_settings = {
    'default_time_range'      => $default_time_range,
    'default_time_range_unit' => $default_time_range_unit,
    'disable_no_graphs_found' => $disable_no_graphs,
  }

  $settings = {
    'module-graphite-graphite' => {
      'section_name' => 'graphite',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($graphite_settings),
    },
    'module-graphite-icinga' => {
      'section_name' => 'icinga',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($icinga_settings),
    },
    'module-graphite-ui' => {
      'section_name' => 'ui',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($ui_settings),
    },
  }

  icingaweb2::module { 'graphite':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
    settings       => $settings,
  }
}
