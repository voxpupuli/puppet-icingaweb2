# Puppet icingaweb2

## Requirements

* [stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)
* [vcsrepo](https://github.com/puppetlabs/puppet-vcsrepo)

Debian and derivatives only:

* Puppetlabs [apt module](https://github.com/puppetlabs/puppetlabs-apt) or
* Camptocamp [apt module](https://github.com/camptocamp/puppet-apt)

## Example usage

### Install IcingaWeb2

    node /box/ {
      include icingaweb2
    }

### Install method: packages

    node /box/ {
      class { 'icingaweb2':
        install_method => 'package',
      }
    }

### Install method: Git

    node /box/ {
      class { 'icingaweb2':
        install_method => 'git',
      }
    }

### Manage repository

    node /box/ {
      class { 'icingaweb2':
        manage_repo    => true,
        install_method => 'package',
      }
    }

### Business process module

    node /box/ {
      class {
        'icingaweb2':;
        'icingaweb2::mod::businessprocess':;
      }
    }

### Deployment module

    node /box/ {
      class {
        'icingaweb2':;
        'icingaweb2::mod::deployment':
          auth_token => 'secret_token';
      }
    }

### Graphite module

    node /box/ {
      class {
        'icingaweb2':;
        'icingaweb2::mod::graphite':
          graphite_base_url => 'http://graphite.com/render?';
      }
    }

### NagVis module

    node /box/ {
      class {
        'icingaweb2':;
        'icingaweb2::mod::nagvis':
          nagvis_url => 'http://example.org/nagvis/';
      }
    }

## Contributing

* Fork it
* Create a feature branch (`git checkout -b my-new-feature`)
* Run rspec tests (`bundle exec rake spec`)
* Commit your changes (`git commit -am 'Added some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create new Pull Request
