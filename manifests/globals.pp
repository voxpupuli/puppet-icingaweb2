# @summary
#   This class loads the default parameters by doing a hiera lookup.
#
# @note This parameters depend on the os plattform. Changes maybe will break the functional capability of the supported plattforms and versions. Please only do changes when you know what you're doing.
#
# @param package_name
#
# @param conf_dir
#   Path to the config files.
#
# @param default_module_path
#   Location of the modules.
#
# @param mysql_db_schema
#   Location of the database schema for MySQL/MariaDB.
#
# @param pgsql_db_schema
#   Location of the database schema for PostgreSQL.
#
# @param mysql_vspheredb_schema
#   Location of the vspheredb database schema for MySQL/MariaDB.
#
# @param pgsql_vspheredb_schema
#   Location of the vspheredb database schema for PostgreSQL.
#
# @param mysql_reporting_schema
#   Location of the reporting database schema for MySQL/MariaDB.
#
# @param pgsql_reporting_schema
#   Location of the reporting database schema for PostgreSQL.
#
# @param mysql_idoreports_slaperiods
#   Location of the slaperiods database extension for MySQL.
#
# @param mysql_idoreports_sla_percent
#   Location of the get_sla_ok_percent database extension for MySQL.
#
# @param pgsql_idoreports_slaperiods
#   Location of the slaperiods database extension for PostgreSQL.
#
# @param pgsql_idoreports_sla_percent
#   Location of the get_sla_ok_percent database extension for PostgreSQL.
#
# @param gettext_package_name
#   Package name `gettext` tool belongs to.
#
# @param icingacli_bin
#   Path to `icingacli' comand line tool.
#
class icingaweb2::globals (
  String                 $package_name,
  Stdlib::Absolutepath   $conf_dir,
  Stdlib::Absolutepath   $default_module_path,
  Stdlib::Absolutepath   $mysql_db_schema,
  Stdlib::Absolutepath   $pgsql_db_schema,
  Stdlib::Absolutepath   $mysql_vspheredb_schema,
  Stdlib::Absolutepath   $pgsql_vspheredb_schema,
  Stdlib::Absolutepath   $mysql_reporting_schema,
  Stdlib::Absolutepath   $pgsql_reporting_schema,
  Stdlib::Absolutepath   $mysql_idoreports_slaperiods,
  Stdlib::Absolutepath   $mysql_idoreports_sla_percent,
  Stdlib::Absolutepath   $pgsql_idoreports_slaperiods,
  Stdlib::Absolutepath   $pgsql_idoreports_sla_percent,
  String                 $gettext_package_name,
  Stdlib::Absolutepath   $icingacli_bin,
) {
  $port = {
    'mysql' => 3306,
    'pgsql' => 5432,
  }
}
