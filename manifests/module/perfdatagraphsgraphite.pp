# @summary
#   Installs and enables the perfdatagraphs-graphite module.
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
#   Set either a branch or a tag name, eg. `main` or `v0.1.1`.
#
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param url
#   URI to the graphite API.
#
# @param timeout
#   HTTP timeout for the API in seconds.
#
# @param max_data_points
#   The maximum numbers of datapoints each series returns. Disable aggregation by setting this to 0.
#
# @param writer_host_name_template
#   Host template. See Icinga 2 feature `graphite`.
#
# @param writer_service_name_template
#   Service template. See Icinga 2 feature `graphite`.
#
# @param auth_method
#   Authentication method to use for the API.
#
# @param auth_basic
#   Username and password for HTTP basic authentication.
#
# @param auth_token
#   Type and value for the Authorization header token.
#
# @param use_mtls
#   Use client certificate authentication.
#
# @param mtls_cert_file
#   Path to an existing client certificate file.
#
# @param mtls_key_file
#   Path to an existing client key file.
#
# @param mtls_cacert_file
#   Path to an existing client CA file.
#
# @param mtls_cert
#   Client certificate content to manage.
#
# @param mtls_key
#   Client private key content to manage.
#
# @param mtls_cacert
#   Client CA certificate content to manage.
#
# @param tls_insecure
#   Wether to validate the certificate of the graphite API.
#
class icingaweb2::module::perfdatagraphsgraphite (
  Enum['absent', 'present']       $ensure                       = 'present',
  Enum['git', 'none', 'package']  $install_method               = 'git',
  Optional[String[1]]             $package_name                 = undef,
  Stdlib::HTTPUrl                 $git_repository               = 'https://github.com/NETWAYS/icingaweb2-module-perfdatagraphs-graphite.git',
  Optional[String[1]]             $git_revision                 = undef,
  Stdlib::Absolutepath            $module_dir                   = "${icingaweb2::globals::default_module_path}/perfdatagraphsgraphite",
  Stdlib::HTTPUrl                 $url                          = 'http://127.0.0.1:8542',
  Optional[Integer[1]]            $timeout                      = undef,
  Optional[Integer[0]]            $max_data_points              = undef,
  Optional[String[1]]             $writer_host_name_template    = undef,
  Optional[String[1]]             $writer_service_name_template = undef,
  Enum['none', 'basic', 'token']  $auth_method                  = 'none',
  Optional[Icingaweb2::BasicAuth] $auth_basic                   = undef,
  Optional[Icingaweb2::TokenAuth] $auth_token                   = undef,
  Boolean                         $use_mtls                     = false,
  Optional[Stdlib::Absolutepath]  $mtls_cert_file                = undef,
  Optional[Stdlib::Absolutepath]  $mtls_key_file                 = undef,
  Optional[Stdlib::Absolutepath]  $mtls_cacert_file              = undef,
  Optional[String[1]]             $mtls_cert                     = undef,
  Optional[Icinga::Secret]        $mtls_key                      = undef,
  Optional[String[1]]             $mtls_cacert                   = undef,
  Boolean                         $tls_insecure                 = false,
) {
  require icingaweb2::module::perfdatagraphs

  $conf_dir        = $icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/perfdatagraphsgraphite"
  $cert_dir        = "${icingaweb2::globals::state_dir}/certs/perfdatagraphsgraphite"
  $mtls            = icinga::cert::files(
    'perfdatagraphsgraphite',
    $cert_dir,
    $mtls_key_file,
    $mtls_cert_file,
    $mtls_cacert_file,
    $mtls_key,
    $mtls_cert,
    $mtls_cacert,
  )

  if $mtls_key or $mtls_cert or $mtls_cacert {
    file { $cert_dir:
      ensure => directory,
      owner  => 'root',
      group  => $icingaweb2::conf_group,
      mode   => '2770',
    }
    -> icinga::cert { 'icingaweb2::module::perfdatagraphsgraphite mTLS client':
      owner => $icingaweb2::conf_user,
      group => $icingaweb2::conf_group,
      args  => $mtls,
    }
  }

  if $use_mtls and (!$mtls['cert_file'] or !$mtls['key_file']) {
    fail('Client certificate and key files are required when use_mtls is enabled.')
  }

  $config_settings = {
    api_url                      => $url,
    api_timeout                  => $timeout,
    max_data_points              => $max_data_points,
    writer_host_name_template    => $writer_host_name_template,
    writer_service_name_template => $writer_service_name_template,
    api_auth_method              => $auth_method,
    api_auth_mtls                => $use_mtls,
    api_auth_mtls_cert           => $mtls['cert_file'],
    api_auth_mtls_key            => $mtls['key_file'],
    api_auth_mtls_ca             => $mtls['cacert_file'],
    api_tls_insecure             => $tls_insecure,
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
    'icingaweb2-module-perfdatagraphsgraphite' => {
      'section_name' => 'graphite',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($config_settings + $auth_settings),
    },
  }

  icingaweb2::module { 'perfdatagraphsgraphite':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
    settings       => $settings,
  }
}
