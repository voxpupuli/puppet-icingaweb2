# == Define: icingaweb2::preinstall::redhat
#
define icingaweb2::preinstall::redhat(
  $pkg_repo_version,
) {
  if $caller_module_name != $module_name {
    fail 'Tried to include private class icingaweb2::preinstall::redhat'
  }

  case $::operatingsystem {
    'RedHat', 'CentOS', 'Scientific': {
      case $pkg_repo_version {
        'release': {
          yumrepo { "ICINGA-${::icingaweb2::pkg_repo_version}":
            baseurl         => $::icingaweb2::pkg_repo_release_url,
            descr           => "ICINGA (${pkg_repo_version} builds for epel)",
            enabled         => 1,
            gpgcheck        => 1,
            gpgkey          => $::icingaweb2::pkg_repo_release_key,
            metadata_expire => $::icingaweb2::pkg_repo_release_metadata_expire,
          }
        }

        'snapshot': {
          yumrepo { "ICINGA-${::icingaweb2::pkg_repo_version}":
            baseurl         => $::icingaweb2::pkg_repo_snapshot_url,
            descr           => "ICINGA (${pkg_repo_version} builds for epel)",
            enabled         => 1,
            gpgcheck        => 1,
            gpgkey          => $::icingaweb2::pkg_repo_snapshot_key,
            metadata_expire => $::icingaweb2::pkg_repo_snapshot_metadata_expire,
          }
        }

        default: {}
      }
    }

    # TODO 'Debian': {}
    # TODO 'Ubuntu': {}
    # TODO 'Fedora': {}
    # TODO 'Amazon': {}

    default: {
      # Already caught by icingaweb2::preinstall
    }
  }
}

