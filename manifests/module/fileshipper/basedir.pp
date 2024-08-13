# @summary
#   Manages base directories for the fileshipper module.
#
# @param identifier
#   Identifier of the base directory.
#
# @param basedir
#   Absolute path of a direcory.
#
# @api private
#
define icingaweb2::module::fileshipper::basedir (
  String[1]                        $identifier = $title,
  Optional[Stdlib::Absolutepath]   $basedir    = undef,
) {
  assert_private("You're not supposed to use this defined type manually.")

  $module_conf_dir = $icingaweb2::module::fileshipper::module_conf_dir

  icingaweb2::inisection { "fileshipper-basedir-${identifier}":
    section_name => $identifier,
    target       => "${module_conf_dir}/imports.ini",
    settings     => {
      'basedir' => $basedir,
    },
  }
}
