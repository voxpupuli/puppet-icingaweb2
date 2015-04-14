# Icingaweb2
#
# This Part was taken from icinga2 Module
#

define icingaweb2::modules (
  $enabled  = $::icingaweb2::modules_enabled,
  $disabled = $::icingaweb2::modules_disabled,
) {

  include stdlib

  # Do some checking
  validate_array( $enabled )
  validate_array( $disabled )

  # Compare the enabled and disabled feature arrays
  # Remove enabled features that are also listed to be disabled
  $updated_enabled_modules = difference( $enabled, $disabled )

  # Pass the disabled features array to the define for looping
  icingaweb2::modules::disable {
    $disabled:
  }

  # Pass the features array to the define for looping
  icingaweb2::modules::enable {
    $updated_enabled_modules:
  }

}

# EOF

