[![Build Status](https://travis-ci.org/Icinga/puppet-icingaweb2.png?branch=v2)](https://travis-ci.org/Icinga/puppet-icingaweb2)

# Icinga Web 2 Puppet Module

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with Icinga Web 2](#setup)
    * [What Icinga Web 2 affects](##what-icinga-web-2-affects)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Public Classes](#public-classes)
    * [Private Classes](#private-classes)
    * [Public defined types](#public-defined-types)
    * [Private defined types](#private-defined-types)
6. [Development - Guide for contributing to the module](#development)

## Overview
[Icinga Web 2](https://www.icinga.com/products/icinga-web-2/) is the associated web interface for the open source
monitoring tool [Icinga 2](https://www.icinga.com/products/icinga-2/). This module helps with installing and managing
configuration of Icinga Web 2 and its modules on multiple operating systems.

## Description

This module installs and configures Icinga Web 2 on your Linux host by using the official packages from
[packages.icinga.com](https://packages.icinga.com). Dependend packages are installed as they are defined in the
Icinga Web 2 package.

The module can manage all configurations files of Icinga Web 2 and import an initial database schema. It can install and
manage all official [modules](https://www.icinga.com/products/icinga-web-2-modules/) by cloning the repositories.
Community driven modules can be installed but not managed.

## Setup

### What the Icinga 2 Puppet module supports

* Installation of Icinga Web 2 via packages
* Configuration
* MySQL / PostgreSQL database schema import
* Install and manage official Icinga Web 2 modules
* Install community modules

### Dependencies

This module depends on

* [puppetlabs/apache](https://forge.puppet.com/puppetlabs/apache) >= 1.2.0
* [puppetlabs/inifile](https://forge.puppet.com/puppetlabs/inifile) >= 1.2.0
* [puppetlabs/stdlib](https://forge.puppet.com/puppetlabs/stdlib) >= 4.4.0
* [puppetlabs/vcsrepo](https://forge.puppet.com/puppetlabs/vcsrepo) >= 1.2.0

### Limitations

This module has been tested on:

* Debian 7, 8
* CentOS/RHEL 6, 7
* Ubuntu 14.04, 16.04
* SLES 12

Other operating systems or versions may work but have not been tested.

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

### Initialize db

Default Credentials will be icingaadmin:icinga

    node /box/ {
      class { 'icingaweb2':
        initialize => true,
      }
    }

### Manage repository

**Note:** This will add the same repositories as `icinga/icinga2`, make sure you only enable one.

``` puppet
class { '::icingaweb2':
  manage_repo    => true,
  install_method => 'package',
}
```

### Monitoring module

In minimal default configuration:

``` puppet
include ::icingaweb2
include ::icingaweb2::mod::monitoring
```

With transport configuration

``` puppet
include ::icingaweb2

# default is local
class { '::icingaweb2::mod::monitoring':
  transport      => 'local',
  transport_path => '/run/icinga2/cmd/icinga2.cmd',
}

# via SSH, make sure to add a SSH key to the user running PHP (apache)
class { '::icingaweb2::mod::monitoring':
  transport          => 'remote',
  transport_host     => 'icinga-master1',
  transport_username => 'icingaweb',
  transport_path     => '/run/icinga2/cmd/icinga2.cmd',
}

# via Icinga 2 API
class { '::icingaweb2::mod::monitoring':
  transport          => 'api',
  transport_host     => 'icinga-master1',
  transport_username => 'icingaweb2',
  transport_password => 'secret',
}
```

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

### Real world example

Icinga2 is installed or on another host. One needs only the ido data to configure icingaweb2.
This could be a profile class to include icingaweb2 in a architecture with roles and profiles.

    class profile::icingaweb2(){
      $ido_db_name = hiera('icinga2::ido::name', 'icinga2')
      $ido_db_user = hiera('icinga2::ido::user', 'icinga2')
      $ido_db_pass = hiera('icinga2::ido::password', 'icinga2')
      $web_db_name = hiera('icingaweb2::db::name', 'icingaweb2')
      $web_db_user = hiera('icingaweb2::db::user', 'icingaweb2')
      $web_db_pass = hiera('icingaweb2::db::password', 'icingaweb2')

      contain '::mysql::server'
      contain '::mysql::client'
      contain '::mysql::server::account_security'

      contain '::apache'
      contain '::apache::mod::php'

      Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

      ::mysql::db { $web_db_name:
        user     => $web_db_user,
        password => $web_db_pass,
        host     => 'localhost',
        grant    => ['ALL'],
      }

      class { '::icingaweb2':
        initialize          => true,
        install_method      => 'package',
        manage_apache_vhost => true,
        ido_db_name         => $ido_db_name,
        ido_db_pass         => $ido_db_pass,
        ido_db_user         => $ido_db_user,
        web_db_name         => $web_db_name,
        web_db_pass         => $web_db_pass,
        web_db_user         => $web_db_user,
        require             => Class['::mysql::server'],
      } ->

      augeas { 'php.ini':
        context => '/files/etc/php.ini/PHP',
        changes => ['set date.timezone Europe/Berlin',],
      }

      contain ::icingaweb2::mod::monitoring
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
