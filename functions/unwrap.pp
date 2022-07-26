# @summary
#   This function returns an unwrap string if necessary.
#
# @return
#   The unwraped string.
#
function icingaweb2::unwrap(Optional[Variant[String, Sensitive[String]]] $arg = undef) {
  # @param arg
  #   A sensitive or string.
  #
  if $arg =~ Sensitive {
    $arg.unwrap
  } else {
    $arg
  }
}
