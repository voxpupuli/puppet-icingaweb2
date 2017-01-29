# == Class icingaweb2::install
#
class icingaweb2::install {
  if $::icingaweb2::install_method == 'package' {
    if $::icingaweb2::pkg_list {
      package { $::icingaweb2::pkg_list:
        ensure => $::icingaweb2::pkg_ensure,
      }
    }

    if $::icingaweb2::pkg_deps {
      package { $::icingaweb2::pkg_deps:
        ensure => $::icingaweb2::pkg_ensure,
        before => Package[$::icingaweb2::pkg_list],
      }
    }
  }

  if $::icingaweb2::install_method == 'git' {
    if $::icingaweb2::pkg_deps {
      package { $::icingaweb2::pkg_deps:
        ensure => $::icingaweb2::pkg_ensure,
        before => Vcsrepo['icingaweb2'],
      }
    }

    ensure_packages(['git'])

    vcsrepo { 'icingaweb2':
      ensure   => present,
      path     => $::icingaweb2::web_root,
      provider => 'git',
      revision => $::icingaweb2::git_revision,
      source   => $::icingaweb2::git_repo,
      require  => Package['git'],
    }
  }
}

