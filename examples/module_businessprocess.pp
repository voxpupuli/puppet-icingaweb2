include icingaweb2

package { 'git': }

class { 'icingaweb2::module::businessprocess':
  git_revision => 'v2.1.0',
}
