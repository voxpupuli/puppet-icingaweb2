# @summary
#   Installs, configures and enables the idoreports module.
#
# @note If you want to use `git` as `install_method`, the CLI `git` command has to be installed. You can manage it yourself as package resource or declare the package name in icingaweb2 class parameter `extra_packages`.
#
# @param ensure
#   Enable or disable module. Specific states can also be defined, depending on the `install_method`.
#   For package installations, it represents the package state, for git managed modules it defines
#   the revision to check out.
#
# @param module_dir
#   Target directory of the module.
#
# @param git_repository
#   Set a git repository URL.
#
# @param git_revision
#   Set either a branch or a tag name, eg. `master` or `v2.1.0`.
#
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param import_schema
#   The IDO database needs some extensions for reorting. Whether to import the database extensions or not.
#   Options `mariadb` and `mysql`, both means true. With mariadb its cli options are used for the import,
#   whereas with mysql its different options.
#
# @param ido_db_username
#   An alternative username to login into the database. By default, the user from
#   the `monitoring` module is used.
#
# @param ido_db_password
#   The password for the alternative user. By default, the password from
#   the `monitoring` module is used.
#
# @param use_tls
#   Either enable or disable TLS encryption to the database. Other TLS parameters
#   are only affected if this is set to 'true'. By default, same value from
#   the `monitoring` module is used.
#
# @param tls_key_file
#   Location of the private key for client authentication. Only valid if tls is enabled.
#   By default, same value from the `monitoring` module is used.
#
# @param tls_cert_file
#   Location of the certificate for client authentication. Only valid if tls is enabled.
#   By default, same value from the `monitoring` module is used.
#
# @param tls_cacert_file
#   Location of the ca certificate. Only valid if tls is enabled.
#   By default, same value from the `monitoring` module is used.
#
# @param tls_key
#   The private key to store in spicified `tls_key_file` file. Only valid if tls is enabled.
#   By default, same value from the `monitoring` module is used.
#
# @param tls_cert
#   The certificate to store in spicified `tls_cert_file` file. Only valid if tls is enabled.
#   By default, same value from the `monitoring` module is used.
#
# @param tls_cacert
#   The ca certificate to store in spicified `tls_cacert_file` file. Only valid if tls is enabled.
#   By default, same value from the `monitoring` module is used.
#
# @param tls_capath
#   The file path to the directory that contains the trusted SSL CA certificates, which are stored in PEM format.
#   Only available for the mysql database. By default, same value from the `monitoring` module is used.
#
# @param tls_noverify
#   Disable validation of the server certificate. By default, same value from the `monitoring` module is used.
#
# @param tls_cipher
#   Cipher to use for the encrypted database connection. By default, same value from the `monitoring` module is used.
#
# @example
#   class { 'icingaweb2::module::idoreports':
#     git_revision  => 'v0.10.0',
#   }
#
class icingaweb2::module::idoreports (
  String                                     $ensure,
  Enum['git', 'none', 'package']             $install_method,
  String                                     $git_repository,
  String                                     $package_name,
  Optional[Stdlib::Absolutepath]             $module_dir      = undef,
  Optional[String]                           $git_revision    = undef,
  Variant[Boolean, Enum['mariadb', 'mysql']] $import_schema   = false,
  Optional[String]                           $ido_db_username = $icingaweb2::module::monitoring::ido_db_username,
  Optional[Icingaweb2::Secret]               $ido_db_password = $icingaweb2::module::monitoring::ido_db_password,
  Optional[Boolean]                          $use_tls         = $icingaweb2::module::monitoring::use_tls,
  Optional[Stdlib::Absolutepath]             $tls_key_file    = $icingaweb2::module::monitoring::tls_key_file,
  Optional[Stdlib::Absolutepath]             $tls_cert_file   = $icingaweb2::module::monitoring::tls_cert_file,
  Optional[Stdlib::Absolutepath]             $tls_cacert_file = $icingaweb2::module::monitoring::tls_cacert_file,
  Optional[Stdlib::Absolutepath]             $tls_capath      = $icingaweb2::module::monitoring::tls_capath,
  Optional[Icingaweb2::Secret]               $tls_key         = $icingaweb2::module::monitoring::tls_key,
  Optional[String]                           $tls_cert        = $icingaweb2::module::monitoring::tls_cert,
  Optional[String]                           $tls_cacert      = $icingaweb2::module::monitoring::tls_cacert,
  Optional[Boolean]                          $tls_noverify    = $icingaweb2::module::monitoring::tls_noverify,
  Optional[String]                           $tls_cipher      = $icingaweb2::module::monitoring::tls_cipher,
) {
  unless defined(Class['icingaweb2::module::monitoring']) {
    fail('You must declare the icingaweb2::module::monitoring class before using icingaweb2::module::idoreports!')
  }

  $conf_dir          = $icingaweb2::globals::conf_dir
  $module_conf_dir   = "${conf_dir}/modules/idoreports"

  Exec {
    path     => $facts['path'],
    provider => shell,
    user     => 'root',
    require  => Icingaweb2::Module['idoreports'],
  }

  icingaweb2::module { 'idoreports':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
    settings       => {
      'module-idoreports-config' => {
        target => "${module_conf_dir}/config.ini",
      },
    },
  }

  if $import_schema {
    $db = {
      type => $icingaweb2::module::monitoring::ido_type,
      host => $icingaweb2::module::monitoring::ido_host,
      port => pick($icingaweb2::module::monitoring::ido_port, $icingaweb2::globals::port[$icingaweb2::module::monitoring::ido_type]),
      name => $icingaweb2::module::monitoring::ido_db_name,
      user => $ido_db_username,
      pass => $ido_db_password,
    }

    $tls = merge(delete($icingaweb2::config::tls, ['key', 'cert', 'cacert']), delete_undef_values(merge(icingaweb2::cert::files(
            'client',
            $module_conf_dir,
            $tls_key_file,
            $tls_cert_file,
            $tls_cacert_file,
            $tls_key,
            $tls_cert,
            $tls_cacert,
          ), {
            capath   => $tls_capath,
            noverify => $tls_noverify,
            cipher   => $tls_cipher,
    })))

    icingaweb2::tls::client { 'icingaweb2::module::idoreports tls client config':
      args => $tls,
    }

    # determine the real dbms, because there are some differnces between
    # the mysql and mariadb client
    $real_db_type = if $import_schema =~ Boolean {
      if $db['type'] == 'pgsql' { 'pgsql' } else { 'mariadb' }
    } else {
      $import_schema
    }
    $db_cli_options = icingaweb2::db::connect($db + { type => $real_db_type }, $tls, $use_tls)

    case $db['type'] {
      'mysql': {
        exec { 'import slaperiods':
          command => "mysql ${db_cli_options} < '${icingaweb2::globals::mysql_idoreports_slaperiods}'",
          unless  => "mysql ${db_cli_options} -Ns -e 'SELECT 1 FROM icinga_sla_periods'",
        }
        exec { 'import get_sla_ok_percent':
          command => "mysql ${db_cli_options} < '${icingaweb2::globals::mysql_idoreports_sla_percent}'",
          unless  => "if [ \"X$(mysql ${db_cli_options} -Ns -e 'SELECT 1 FROM information_schema.routines WHERE routine_name=\"idoreports_get_sla_ok_percent\"')\" != \"X1\" ];then exit 1; fi",
        }
      }
      'pgsql': {
        $_db_password = icingaweb2::unwrap($db['pass'])
        exec { 'import slaperiods':
          environment => ["PGPASSWORD=${_db_password}"],
          command     => "psql '${db_cli_options}' -w -f ${icingaweb2::globals::pgsql_idoreports_slaperiods}",
          unless      => "psql '${db_cli_options}' -w -c 'SELECT 1 FROM icinga_outofsla_periods'",
        }
        exec { 'import get_sla_ok_percent':
          environment => ["PGPASSWORD=${_db_password}"],
          command     => "psql '${db_cli_options}' -w -f ${icingaweb2::globals::pgsql_idoreports_sla_percent}",
          unless      => "if [ \"X$(psql '${db_cli_options}' -w -t -c \"SELECT 1 FROM information_schema.routines WHERE routine_name='idoreports_get_sla_ok_percent'\"|xargs)\" != \"X1\" ];then exit 1; fi",
        }
      }
      default: {
        fail('The database type you provided is not supported.')
      }
    }
  }
}
