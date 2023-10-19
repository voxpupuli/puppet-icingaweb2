# @summary Installs the reporting module
#
# @param ensure
#   Ensures the state of the reporting module.
#
# @param module_dir
#   Target directory of the module.
#
# @param git_repository
#   The upstream module repository.
#
# @param git_revision
#   The version of the module that needs to be used.
#
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param db_type
#   The database type. Either mysql or postgres.
#
# @param db_host
#   The host where the reporting database will be running
#
# @param db_port
#   The port on which the database is accessible.
#
# @param db_name
#   The name of the database this module should use.
#
# @param db_username
#   The username needed to access the database.
#
# @param db_password
#   The password needed to access the database.
#
# @param db_charset
#   The charset the database is set to.
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
#   Whether to import the database schema or not. Options `mariadb` and `mysql`,
#   both means true. With mariadb its cli options are used for the import,
#   whereas with mysql its different options.
#
# @param mail
#   Mails are sent with this sender address.
#
# @example
#   class { 'icingaweb2::module::reporting':
#     ensure       => present,
#     git_revision => 'v0.9.0',
#     db_host      => 'localhost',
#     db_name      => 'reporting',
#     db_username  => 'reporting',
#     db_password  => 'supersecret',
#   }
#
class icingaweb2::module::reporting (
  Enum['absent', 'present']                  $ensure,
  Enum['git', 'none', 'package']             $install_method,
  String                                     $git_repository,
  String                                     $package_name,
  Enum['mysql', 'pgsql']                     $db_type,
  Optional[Stdlib::Absolutepath]             $module_dir      = undef,
  Optional[String]                           $git_revision    = undef,
  Stdlib::Host                               $db_host         = 'localhost',
  Optional[Stdlib::Port]                     $db_port         = undef,
  String                                     $db_name         = 'reporting',
  String                                     $db_username     = 'reporting',
  Optional[Icingaweb2::Secret]               $db_password     = undef,
  Optional[String]                           $db_charset      = undef,
  Variant[Boolean, Enum['mariadb', 'mysql']] $import_schema   = false,
  Optional[Boolean]                          $use_tls         = undef,
  Optional[Stdlib::Absolutepath]             $tls_key_file    = undef,
  Optional[Stdlib::Absolutepath]             $tls_cert_file   = undef,
  Optional[Stdlib::Absolutepath]             $tls_cacert_file = undef,
  Optional[Stdlib::Absolutepath]             $tls_capath      = undef,
  Optional[Icingaweb2::Secret]               $tls_key         = undef,
  Optional[String]                           $tls_cert        = undef,
  Optional[String]                           $tls_cacert      = undef,
  Optional[Boolean]                          $tls_noverify    = undef,
  Optional[String]                           $tls_cipher      = undef,
  Optional[String]                           $mail            = undef,
) {
  icingaweb2::assert_module()

  $conf_dir               = $icingaweb2::globals::conf_dir
  $mysql_reporting_schema = $icingaweb2::globals::mysql_reporting_schema
  $pgsql_reporting_schema = $icingaweb2::globals::pgsql_reporting_schema
  $module_conf_dir        = "${conf_dir}/modules/reporting"
  $_db_port               = pick($db_port, $icingaweb2::globals::port[$db_type])

  $_db_charset = if $db_charset {
    $db_charset
  } else {
    if $db_type == 'mysql' {
      'utf8mb4'
    } else {
      'UTF8'
    }
  }

  $tls = delete($icingaweb2::config::tls, ['key', 'cert', 'cacert']) + delete_undef_values(icingaweb2::cert::files(
      'client',
      $module_conf_dir,
      $tls_key_file,
      $tls_cert_file,
      $tls_cacert_file,
      $tls_key,
      $tls_cert,
      $tls_cacert,
    ) + {
      capath   => $tls_capath,
      noverify => $tls_noverify,
      cipher   => $tls_cipher,
  })

  Exec {
    user     => 'root',
    path     => $facts['path'],
    provider => 'shell',
    require  => [Icingaweb2::Module['reporting'], Icingaweb2::Tls::Client['icingaweb2::module::reporting tls client config']],
  }

  icingaweb2::tls::client { 'icingaweb2::module::reporting tls client config':
    args => $tls,
  }

  icingaweb2::resource::database { 'reporting':
    type         => $db_type,
    host         => $db_host,
    port         => $_db_port,
    database     => $db_name,
    username     => $db_username,
    password     => $db_password,
    charset      => $_db_charset,
    use_tls      => $use_tls,
    tls_noverify => $tls['noverify'],
    tls_key      => $tls['key_file'],
    tls_cert     => $tls['cert_file'],
    tls_cacert   => $tls['cacert_file'],
    tls_capath   => $tls['capath'],
    tls_cipher   => $tls['cipher'],
  }

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

  if $import_schema {
    $real_db_type = if $import_schema =~ Boolean {
      if $db_type == 'pgsql' { 'pgsql' } else { 'mariadb' }
    } else {
      $import_schema
    }
    $db_cli_options = icingaweb2::db::connect({
        type => $real_db_type,
        name => $db_name,
        host => $db_host,
        port => $_db_port,
        user => $db_username,
        pass => $db_password,
    }, $tls, $use_tls)

    case $db_type {
      'mysql': {
        exec { 'import icingaweb2::module::reporting schema':
          command => "mysql ${db_cli_options} < '${mysql_reporting_schema}'",
          unless  => "mysql ${db_cli_options} -Ns -e 'SELECT * FROM report'",
        }
      }
      'pgsql': {
        $_db_password = icingaweb2::unwrap($db_password)
        exec { 'import icingaweb2::module::reporting schema':
          environment => ["PGPASSWORD=${_db_password}"],
          command     => "psql '${db_cli_options}' -w -f ${pgsql_reporting_schema}",
          unless      => "psql '${db_cli_options}' -w -c 'SELECT * FROM report'",
        }
      } # pgsql (not supported)
      default: {
        fail('The database type you provided is not supported.')
      }
    }
  } # schema import
}
