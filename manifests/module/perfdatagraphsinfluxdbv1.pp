# @summary
#   Installs and enables the perfdatagraphs InfluxDB v1 backend module.
#
# @note If you want to use `git` as `install_method`, the CLI `git` command has to be installed.
#
# @param ensure
#   Enable or disable module.
#
# @param module_dir
#   Target directory of the module.
#
# @param git_repository
#   Set a git repository URL.
#
# @param git_revision
#   Set either a branch or a tag name, eg. `main` or `v1.1.0`.
#
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param url
#   URI to the InfluxDB v1 API.
#
# @param database
#   InfluxDB database containing performance data.
#
# @param timeout
#   HTTP timeout for the API in seconds.
#
# @param max_data_points
#   Maximum datapoints per series. Set to 0 to disable aggregation.
#
# @param writer_host_name_template_tag
#   Host name tag configured in the Icinga 2 InfluxWriter.
#
# @param writer_service_name_template_tag
#   Service name tag configured in the Icinga 2 InfluxWriter.
#
# @param writer_host_template_measurement
#   Host measurement template configured in the Icinga 2 InfluxWriter.
#
# @param writer_service_template_measurement
#   Service measurement template configured in the Icinga 2 InfluxWriter.
#
# @param auth_method
#   Required authentication method: `none`, `basic` or `token`.
#
# @param auth_basic
#   Username and password for HTTP basic authentication.
#
# @param auth_token
#   Type and value for the Authorization header token.
#
# @param use_tls
#   Use client certificate authentication.
#
# @param tls_cert_file
#   Path to an existing client certificate file.
#
# @param tls_key_file
#   Path to an existing client key file.
#
# @param tls_cacert_file
#   Path to an existing client CA file.
#
# @param tls_cert
#   Client certificate content to manage.
#
# @param tls_key
#   Client private key content to manage.
#
# @param tls_cacert
#   Client CA certificate content to manage.
#
# @param tls_insecure
#   Skip verification of the InfluxDB server certificate.
#
class icingaweb2::module::perfdatagraphsinfluxdbv1 (
  String[1]                       $database,
  Enum['none', 'basic', 'token']  $auth_method,
  Enum['absent', 'present']       $ensure                              = 'present',
  Enum['git', 'none', 'package']  $install_method                      = 'git',
  Optional[String[1]]             $package_name                        = undef,
  Stdlib::HTTPUrl                 $git_repository                      = 'https://github.com/NETWAYS/icingaweb2-module-perfdatagraphs-influxdbv1.git',
  Optional[String[1]]             $git_revision                        = undef,
  Stdlib::Absolutepath            $module_dir                          = "${icingaweb2::globals::default_module_path}/perfdatagraphsinfluxdbv1",
  Stdlib::HTTPUrl                 $url                                 = 'http://127.0.0.1:8086',
  Optional[Integer[1]]            $timeout                             = undef,
  Optional[Integer[0]]            $max_data_points                     = undef,
  Optional[String[1]]             $writer_host_name_template_tag       = undef,
  Optional[String[1]]             $writer_service_name_template_tag    = undef,
  Optional[String[1]]             $writer_host_template_measurement    = undef,
  Optional[String[1]]             $writer_service_template_measurement = undef,
  Optional[Icingaweb2::BasicAuth] $auth_basic                          = undef,
  Optional[Icingaweb2::TokenAuth] $auth_token                          = undef,
  Boolean                         $use_tls                              = false,
  Optional[Stdlib::Absolutepath]  $tls_cert_file                        = undef,
  Optional[Stdlib::Absolutepath]  $tls_key_file                         = undef,
  Optional[Stdlib::Absolutepath]  $tls_cacert_file                      = undef,
  Optional[String[1]]             $tls_cert                             = undef,
  Optional[Icinga::Secret]        $tls_key                              = undef,
  Optional[String[1]]             $tls_cacert                           = undef,
  Boolean                         $tls_insecure                        = false,
) {
  require icingaweb2::module::perfdatagraphs

  $conf_dir        = $icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/perfdatagraphsinfluxdbv1"
  $cert_dir        = "${icingaweb2::globals::state_dir}/certs/perfdatagraphsinfluxdbv1"
  $tls             = icinga::cert::files(
    'perfdatagraphsinfluxdbv1',
    $cert_dir,
    $tls_key_file,
    $tls_cert_file,
    $tls_cacert_file,
    $tls_key,
    $tls_cert,
    $tls_cacert,
  )

  if $tls_key or $tls_cert or $tls_cacert {
    file { $cert_dir:
      ensure => directory,
      owner  => 'root',
      group  => $icingaweb2::conf_group,
      mode   => '2770',
    }
    -> icinga::cert { 'icingaweb2::module::perfdatagraphsinfluxdbv1 mTLS client':
      owner => $icingaweb2::conf_user,
      group => $icingaweb2::conf_group,
      args  => $tls,
    }
  }

  if $use_tls and (!$tls['cert_file'] or !$tls['key_file']) {
    fail('Client certificate and key files are required when use_tls is enabled.')
  }

  $config_settings = {
    api_url                             => $url,
    api_database                        => $database,
    api_timeout                         => $timeout,
    api_max_data_points                 => $max_data_points,
    api_auth_method                     => $auth_method,
    api_auth_mtls                       => $use_tls,
    api_auth_mtls_cert                  => $tls['cert_file'],
    api_auth_mtls_key                   => $tls['key_file'],
    api_auth_mtls_ca                    => $tls['cacert_file'],
    api_tls_insecure                    => $tls_insecure,
    writer_host_name_template_tag       => $writer_host_name_template_tag,
    writer_service_name_template_tag    => $writer_service_name_template_tag,
    writer_host_template_measurement    => $writer_host_template_measurement,
    writer_service_template_measurement => $writer_service_template_measurement,
  }

  case $auth_method {
    'basic': {
      if !$auth_basic {
        fail('auth_basic must be set when auth_method is basic.')
      }

      $auth_password = $auth_basic['password'] =~ Sensitive ? {
        true    => $auth_basic['password'],
        default => Sensitive($auth_basic['password']),
      }
      $auth_settings = {
        api_auth_username => $auth_basic['username'],
        api_auth_password => $auth_password,
      }
    }
    'token': {
      if !$auth_token {
        fail('auth_token must be set when auth_method is token.')
      }

      $auth_token_value = $auth_token['value'] =~ Sensitive ? {
        true    => $auth_token['value'],
        default => Sensitive($auth_token['value']),
      }
      $auth_settings = {
        api_auth_tokentype  => $auth_token['type'],
        api_auth_tokenvalue => $auth_token_value,
      }
    }
    default: {
      $auth_settings = {}
    }
  }

  $settings = {
    'icingaweb2-module-perfdatagraphsinfluxdbv1' => {
      'section_name' => 'influx',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($config_settings + $auth_settings),
    },
  }

  icingaweb2::module { 'perfdatagraphsinfluxdbv1':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
    settings       => $settings,
  }
}
