# @summary
#   This function returns first parameter if set.
#
# @return
#   One of the two parameters.
#
function icingaweb2::pick($arg1, $arg2) {
  # @param arg1
  #   First argument.
  #
  # @param arg2
  #   Second argument.
  #
  unless $arg1 {
    $arg2
  } else {
    $arg1
  }
}
