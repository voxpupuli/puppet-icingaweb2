# @summary
#   This class loads the default parameters by doing a hiera lookup.
#
# @note This parameters depend on the os plattform. Changes maybe will break the functional capability of the supported plattforms and versions. Please only do changes when you know what you're doing.
#
class icingaweb2::globals(
  String                 $package_name,
  Stdlib::Absolutepath   $conf_dir,
  Stdlib::Absolutepath   $mysql_db_schema,
  Stdlib::Absolutepath   $pgsql_db_schema,
  String                 $gettext_package_name,
) {

}
