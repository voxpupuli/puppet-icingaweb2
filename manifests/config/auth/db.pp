#
#
#
#

define icingaweb2::config::auth::db(
  $auth_section  = undef,
  $auth_resource = undef
) {

#   $file = "${::icingaweb2::config_dir}/authentication.ini"
#
#   Ini_Setting {
#     ensure  => present,
#     require => File["${file}"],
#     path    => "${file}"
#   }
#
#   ini_setting {
#     "icingaweb2 authentication ${title} resource":
#       section => "${auth_section}",
#       setting => 'resource',
#       value   => "\"${auth_resource}\"",
#   }
#
#   ini_setting {
#     "icingaweb2 authentication ${title} backend":
#       section => "${auth_section}",
#       setting => 'backend',
#       value   => '"db"',
#   }

}

# EOF
