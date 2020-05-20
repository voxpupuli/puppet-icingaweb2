# @summary
#   Manages directories with plain Icinga 2 configuration files.
#
# @param [String] identifier
#   Identifier of the base directory.
#
# @param [Optional[Stdlib::Absolutepath]] source
#   Absolute path of the source direcory.
#
# @param [Optional[Stdlib::Absolutepath]] target
#   Absolute path of the target direcory.
#
# @param [String] extensions
#   Only files with these extensions will be synced. Defaults to `.conf`
#
# @api private
#
define icingaweb2::module::fileshipper::directory(
  String                           $identifier = $title,
  Optional[Stdlib::Absolutepath]   $source     = undef,
  Optional[Stdlib::Absolutepath]   $target     = undef,
  String                           $extensions = '.conf',
){
  assert_private("You're not supposed to use this defined type manually.")

  $conf_dir        = $::icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/fileshipper"

  icingaweb2::inisection { "fileshipper-directory-${identifier}":
    section_name => $identifier,
    target       => "${module_conf_dir}/directories.ini",
    settings     => {
      'source'     => $source,
      'target'     => $target,
      'extensions' => $extensions,
    }
  }
}
