#
#
#
#

class icingaweb2::modules (
  $enabled  = $::icingaweb2::modules_enabled,
  $disabled = $::icingaweb2::modules_disabled,
) {

#  file {[
#    "${icingaweb2::params::config_dir}/modules",
#    "${icingaweb2::params::config_dir}/modules/monitoring"]:
#      ensure => directory,
#      owner  => $icingaweb2::params::config_user,
#      group  => $icingaweb2::params::config_group,
#      mode   => '0644'
#  }

  include stdlib

  # Do some checking
  validate_array( $enabled_features )
  validate_array( $disabled_features )

  # Compare the enabled and disabled feature arrays
  # Remove enabled features that are also listed to be disabled
  $updated_enabled_features = difference( $enabled_features, $disabled_features )

  # Pass the disabled features array to the define for looping
  icingaweb2::modules::disable {
    $disabled_features:
  }

  # Pass the features array to the define for looping
  icingaweb2::modules::enable {
    $updated_enabled_features:
  }

}

# EOF

