include icingaweb2

package { 'git': }

class { 'icingaweb2::module::audit':
  git_revision => 'v1.0.2',
}
