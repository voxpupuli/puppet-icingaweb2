# @summary
#   Installs, configures and enables the idoreports module. The module is deprecated.
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
# @example
#   class { 'icingaweb2::module::idoreports':
#     git_revision  => 'v0.10.0',
#   }
#
class icingaweb2::module::idoreports (
  Enum['absent', 'present']                  $ensure,
  Enum['git', 'none', 'package']             $install_method,
  Stdlib::HTTPUrl                            $git_repository,
  String                                     $package_name,
  Stdlib::Absolutepath                       $module_dir    = "${icingaweb2::globals::default_module_path}/idoreports",
  Optional[Icingaweb2::ImportSchema]         $import_schema = undef,
  Optional[String]                           $git_revision  = undef,
) {
  unless defined(Class['icingaweb2::module::monitoring']) {
    fail('You must declare the icingaweb2::module::monitoring class before using icingaweb2::module::idoreports!')
  }

  require icingaweb2

  $conf_dir          = $icingaweb2::globals::conf_dir
  $module_conf_dir   = "${conf_dir}/modules/idoreports"
  $mysql_slaperiods  = "${icingaweb2::module::idoreports::module_dir}${icingaweb2::globals::mysql_idoreports_slaperiods}"
  $mysql_sla_percent = "${icingaweb2::module::idoreports::module_dir}${icingaweb2::globals::mysql_idoreports_sla_percent}"
  $pgsql_slaperiods  = "${icingaweb2::module::idoreports::module_dir}${icingaweb2::globals::pgsql_idoreports_slaperiods}"
  $pgsql_sla_percent = "${icingaweb2::module::idoreports::module_dir}${icingaweb2::globals::pgsql_idoreports_sla_percent}"

  Exec {
    path     => $facts['path'],
    provider => shell,
    user     => 'root',
    require  => Class['icingaweb2::module::monitoring'],
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
    $db      = $icingaweb2::module::monitoring::db
    $use_tls = $icingaweb2::module::monitoring::use_tls
    $tls     = $icingaweb2::module::monitoring::config::tls

    # determine the real dbms, because there are some differnces between
    # the mysql and mariadb client
    $real_db_type = if $import_schema =~ Boolean {
      if $db['type'] == 'pgsql' { 'pgsql' } else { 'mariadb' }
    } else {
      $import_schema
    }
    $db_cli_options = icinga::db::connect($db + { type => $real_db_type }, $tls, $use_tls)

    case $db['type'] {
      'mysql': {
        exec { 'import slaperiods':
          command => "mysql ${db_cli_options} < '${mysql_slaperiods}'",
          unless  => "mysql ${db_cli_options} -Ns -e 'SELECT 1 FROM icinga_sla_periods'",
        }
        exec { 'import get_sla_ok_percent':
          command => "mysql ${db_cli_options} < '${mysql_sla_percent}'",
          unless  => "if [ \"X$(mysql ${db_cli_options} -Ns -e 'SELECT 1 FROM information_schema.routines WHERE routine_name=\"idoreports_get_sla_ok_percent\"')\" != \"X1\" ];then exit 1; fi",
        }
      }
      'pgsql': {
        $_db_password = unwrap($db['pass'])
        exec { 'import slaperiods':
          environment => ["PGPASSWORD=${_db_password}"],
          command     => "psql '${db_cli_options}' -w -f ${pgsql_slaperiods}",
          unless      => "psql '${db_cli_options}' -w -c 'SELECT 1 FROM icinga_outofsla_periods'",
        }
        exec { 'import get_sla_ok_percent':
          environment => ["PGPASSWORD=${_db_password}"],
          command     => "psql '${db_cli_options}' -w -f ${pgsql_sla_percent}",
          unless      => "if [ \"X$(psql '${db_cli_options}' -w -t -c \"SELECT 1 FROM information_schema.routines WHERE routine_name='idoreports_get_sla_ok_percent'\"|xargs)\" != \"X1\" ];then exit 1; fi",
        }
      }
      default: {
        fail('The database type you provided is not supported.')
      }
    }
  }
}
