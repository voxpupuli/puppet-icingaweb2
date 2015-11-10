# Icinga Web 2

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with Icinga Web 2](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with Icinga Web 2](#beginning-with-icinga-web-2)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Install using packages](#install-using-packages)
    * [Install using Git](#install-using-git)
    * [Manage repository](#manage-repository)
    * [Business process module](#business-process-module)
    * [Deployment module](#deployment-module)
    * [Graphite module](#graphite-module)
    * [NagVis module](#nagvis-module)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module installs and configures Icinga Web 2.

Icinga Web 2 is the next generation open source monitoring web interface, framework and command-line interface developed by the Icinga Project, supporting Icinga 2, Icinga Core and any other monitoring backend compatible with the Livestatus Protocol.

## Setup

### Setup requirements

Debian and derivatives only:

* Puppetlabs [apt module](https://github.com/puppetlabs/puppetlabs-apt) or
* Camptocamp [apt module](https://github.com/camptocamp/puppet-apt)

### Beginning with Icinga Web 2

    node /box/ {
      include icingaweb2
    }

## Usage

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


## Reference

## Limitations

## Development

* Fork it
* Create a feature branch (`git checkout -b my-new-feature`)
* Run rspec tests (`bundle exec rake spec`)
* Commit your changes (`git commit -am 'Added some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create new Pull Request

