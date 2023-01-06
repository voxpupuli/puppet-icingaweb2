include icingaweb2

package { 'git': }

class { 'icingaweb2::module::cube':
  git_revision => 'v1.0.0',
}
