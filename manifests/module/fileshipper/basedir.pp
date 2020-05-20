# @summary
#   Manages base directories for the fileshipper module.
#
# @param [String] identifier
#   Identifier of the base directory.
#
# @param [Optional[Stdlib::Absolutepath]] basedir
#   Absolute path of a direcory.
#
# @api private
#
define icingaweb2::module::fileshipper::basedir(
  String                           $identifier = $title,
  Optional[Stdlib::Absolutepath]   $basedir    = undef,
){
  assert_private("You're not supposed to use this defined type manually.")

  $conf_dir        = $::icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/fileshipper"

  icingaweb2::inisection { "fileshipper-basedir-${identifier}":
    section_name => $identifier,
    target       => "${module_conf_dir}/imports.ini",
    settings     => {
      'basedir' => $basedir,
    }
  }
}
