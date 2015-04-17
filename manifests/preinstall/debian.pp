# == Define: icingaweb2::preinstall::redhat
#
define icingaweb2::preinstall::debian(
  $pkg_repo_version,
) {
  if is_function_available('assert_private') {
    assert_private()
  } else {
    private()
  }

  case $::operatingsystem {

      #Debian systems:
      'Debian': {
        include apt

        #On Debian (7) icinga2 packages are on backports
        if $use_debmon_repo == false {
          include apt::backports
        } else {

          apt::source { 'debmon':
            location    => 'http://debmon.org/debmon',
            release     => "debmon-${lsbdistcodename}",
            repos       => 'main',
            key_server  => 'keys.gnupg.net',
            key         => '7E55BD75930BB3674BFD6582DC0EE15A29D662D2',
            include_src => false,
            # backports repo use 200
            pin         => '300'
          }

        }
      }

    default: {
      # Already caught by icingaweb2::preinstall
    }
  }
}

