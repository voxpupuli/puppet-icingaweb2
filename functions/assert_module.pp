# @summary
#   This function returns a fail if the icingaweb2 class isn't declared.
#
# @return
#   none
#
function icingaweb2::assert_module() {
  unless defined(Class['icingaweb2']) {
    fail('You must declare the icingaweb2 base class before using any icingaweb2 module class!')
  }
}
