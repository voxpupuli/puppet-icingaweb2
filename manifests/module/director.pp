# @summary
#   Installs and configures the director module.
#
# @note If you want to use `git` as `install_method`, the CLI `git` command has to be installed. You can manage it yourself as package resource or declare the package name in icingaweb2 class parameter `extra_packages`.
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
#   Set either a branch or a tag name, eg. `master` or `v1.3.2`.
#
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param db_type
#   Type of your database. Either `mysql` or `pgsql`.
#
# @param db_host
#   Hostname of the database.
#
# @param db_port
#   Port of the database.
#
# @param db_name
#   Name of the database.
#
# @param db_username
#   Username for DB connection.
#
# @param db_password
#   Password for DB connection.
#
# @param db_charset
#   Character set to use for the database.
#
# @param use_tls
#   Either enable or disable TLS encryption to the database. Other TLS parameters
#   are only affected if this is set to 'true'.
#
# @param tls_key_file
#   Location of the private key for client authentication. Only valid if tls is enabled.
#
# @param tls_cert_file
#   Location of the certificate for client authentication. Only valid if tls is enabled.
#
# @param tls_cacert_file
#   Location of the ca certificate. Only valid if tls is enabled.
#
# @param tls_key
#   The private key to store in spicified `tls_key_file` file. Only valid if tls is enabled.
#
# @param tls_cert
#   The certificate to store in spicified `tls_cert_file` file. Only valid if tls is enabled.
#
# @param tls_cacert
#   The ca certificate to store in spicified `tls_cacert_file` file. Only valid if tls is enabled.
#
# @param tls_capath
#   The file path to the directory that contains the trusted SSL CA certificates, which are stored in PEM format.
#   Only available for the mysql database.
#
# @param tls_noverify
#   Disable validation of the server certificate.
#
# @param tls_cipher
#   Cipher to use for the encrypted database connection.
#
# @param import_schema
#   Import database schema.
#
# @param kickstart
#   Run kickstart command after database migration. This requires `import_schema` to be `true`.
#
# @param endpoint
#   Endpoint object name of Icinga 2 API. This setting is only valid if `kickstart` is `true`.
#
# @param api_host
#   Icinga 2 API hostname. This setting is only valid if `kickstart` is `true`.
#
# @param api_port
#   Icinga 2 API port. This setting is only valid if `kickstart` is `true`.
#
# @param api_username
#   Icinga 2 API username. This setting is only valid if `kickstart` is `true`.
#
# @param api_password
#   Icinga 2 API password. This setting is only valid if `kickstart` is `true`.
#
# @param manage_service
#   Also manage the service (daemon), running and enabled. Otherwise do your config via hiera.
#
# @note Please checkout the [Director module documentation](https://www.icinga.com/docs/director/latest/) for requirements.
#
# @example
#   class { 'icingaweb2::module::director':
#     git_revision  => 'v1.7.2',
#     db_host       => 'localhost',
#     db_name       => 'director',
#     db_username   => 'director',
#     db_password   => 'supersecret',
#     import_schema => true,
#     kickstart     => true,
#     endpoint      => 'puppet-icingaweb2.localdomain',
#     api_username  => 'director',
#     api_password  => 'supersecret',
#     require       => Mysql::Db['director']
#   }
#
class icingaweb2::module::director (
  Enum['mysql', 'pgsql']         $db_type,
  Enum['absent', 'present']      $ensure          = 'present',
  Optional[Stdlib::Absolutepath] $module_dir      = undef,
  String                         $git_repository  = 'https://github.com/Icinga/icingaweb2-module-director.git',
  Optional[String]               $git_revision    = undef,
  Enum['git', 'package', 'none'] $install_method  = 'git',
  String                         $package_name    = 'icingaweb2-module-director',
  Stdlib::Host                   $db_host         = 'localhost',
  Optional[Stdlib::Port]         $db_port         = undef,
  String                         $db_name         = 'director',
  String                         $db_username     = 'director',
  Optional[Icingaweb2::Secret]   $db_password     = undef,
  String                         $db_charset      = 'utf8',
  Boolean                        $manage_service  = true,
  Optional[Boolean]              $use_tls         = undef,
  Optional[Stdlib::Absolutepath] $tls_key_file    = undef,
  Optional[Stdlib::Absolutepath] $tls_cert_file   = undef,
  Optional[Stdlib::Absolutepath] $tls_cacert_file = undef,
  Optional[Stdlib::Absolutepath] $tls_capath      = undef,
  Optional[Icingaweb2::Secret]   $tls_key         = undef,
  Optional[String]               $tls_cert        = undef,
  Optional[String]               $tls_cacert      = undef,
  Optional[Boolean]              $tls_noverify    = undef,
  Optional[String]               $tls_cipher      = undef,
  Boolean                        $import_schema   = false,
  Boolean                        $kickstart       = false,
  Optional[String]               $endpoint        = undef,
  Stdlib::Host                   $api_host        = 'localhost',
  Stdlib::Port                   $api_port        = 5665,
  Optional[String]               $api_username    = undef,
  Optional[Icingaweb2::Secret]   $api_password    = undef,
) {
  icingaweb2::assert_module()

  $module_conf_dir = "${icingaweb2::globals::conf_dir}/modules/director"
  $cert_dir        = "${icingaweb2::globals::state_dir}/director/certs"
  $conf_user       = $icingaweb2::conf_user
  $conf_group      = $icingaweb2::conf_group
  $icingacli_bin   = $icingaweb2::globals::icingacli_bin
  $stdlib_version  = $icingaweb2::globals::stdlib_version

  $tls = delete_undef_values(icinga::cert::files(
      $db_username,
      $cert_dir,
      $tls_key_file,
      $tls_cert_file,
      $tls_cacert_file,
      $tls_key,
      $tls_cert,
      $tls_cacert,
  ))

  Exec {
    user     => 'root',
    path     => $facts['path'],
    provider => 'shell',
  }

  file { $cert_dir:
    ensure => directory,
    owner  => 'root',
    group  => $conf_group,
    mode   => '2770',
  }

  icinga::cert { 'icingaweb2::module::director tls client config':
    owner => $conf_user,
    group => $conf_group,
    args  => $tls,
  }

  icingaweb2::resource::database { 'icingaweb2-module-director':
    type         => $db_type,
    host         => $db_host,
    port         => pick($db_port, $icingaweb2::globals::port[$db_type]),
    database     => $db_name,
    username     => $db_username,
    password     => $db_password,
    charset      => $db_charset,
    use_tls      => $use_tls,
    tls_noverify => unless $tls_noverify { $icingaweb2::config::tls['noverify'] } else { $tls_noverify },
    tls_key      => $tls['key_file'],
    tls_cert     => $tls['cert_file'],
    tls_cacert   => unless $tls_cacert_file { $icingaweb2::config::tls['cacert_file'] } else { $tls_cacert_file },
    tls_capath   => unless $tls_capath { $icingaweb2::config::tls['capath'] } else { $tls_capath },
    tls_cipher   => unless $tls_cipher { $icingaweb2::config::tls['cipher'] } else { $tls_cipher },
  }

  $db_settings = {
    'module-director-db' => {
      'section_name' => 'db',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => {
        'resource'   => 'icingaweb2-module-director',
      },
    },
  }

  if $import_schema {
    if versioncmp($stdlib_version, '9.0.0') < 0 {
      ensure_packages(['icingacli'], { 'ensure' => 'present' })
    } else {
      stdlib::ensure_packages(['icingacli'], { 'ensure' => 'present' })
    }

    exec { 'director-migration':
      command => "${icingacli_bin} director migration run",
      onlyif  => "${icingacli_bin} director migration pending",
      require => [Icinga::Cert['icingaweb2::module::director tls client config'], Icingaweb2::Module['director'], Package['icingacli']],
    }

    if $kickstart {
      $kickstart_settings = {
        'module-director-config' => {
          'section_name' => 'config',
          'target'       => "${module_conf_dir}/kickstart.ini",
          'settings'     => {
            'endpoint'   => $endpoint,
            'host'       => $api_host,
            'port'       => $api_port,
            'username'   => $api_username,
            'password'   => icingaweb2::unwrap($api_password),
          },
        },
      }

      exec { 'director-kickstart':
        command => "${icingacli_bin} director kickstart run",
        onlyif  => "${icingacli_bin} director kickstart required",
        require => Exec['director-migration'],
      }
    } else {
      $kickstart_settings = {}
    }
  } else {
    $kickstart_settings = {}
  }

  icingaweb2::module { 'director':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
    settings       => $db_settings + $kickstart_settings,
  }

  if $manage_service {
    include icingaweb2::module::director::service
  }
}
