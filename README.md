# Icinga Web 2

[![Puppet Forge](http://img.shields.io/puppetforge/v/icinga/icingaweb2.svg)](https://forge.puppet.com/icinga/icingaweb2)
[![Build Status](https://travis-ci.org/Icinga/puppet-icingaweb2.png?branch=master)](https://travis-ci.org/Icinga/puppet-icingaweb2)
[![Github Tag](https://img.shields.io/github/tag/Icinga/puppet-icingaweb2.svg)](https://github.com/Icinga/puppet-icingaweb2)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/icinga/icingaweb2.svg)](https://forge.puppetlabs.com/icinga/icingaweb2)

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

### Mysql

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

### Postgresql

    class profile::icingaweb2(){
      $ido_db_name = hiera('icinga2::ido::name', 'icinga2')
      $ido_db_user = hiera('icinga2::ido::user', 'icinga2')
      $ido_db_pass = hiera('icinga2::ido::password', 'icinga2')
      $web_db_name = hiera('icingaweb2::db::name', 'icingaweb2')
      $web_db_user = hiera('icingaweb2::db::user', 'icingaweb2')
      $web_db_pass = hiera('icingaweb2::db::password', 'icingaweb2')

      contain '::postgresql::server'

      contain '::apache'
      contain '::apache::mod::php'

      Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

      postgresql::server::db { "$web_db_name":
        user     => "$web_db_user",
        password => postgresql_password("$web_db_name", " $web_db_pass"),
      }

      class { '::icingaweb2':
        initialize          => true,
        install_method      => 'package',
        manage_apache_vhost => true,
        ido_db_name         => $ido_db_name,
        ido_db_pass         => $ido_db_pass,
        ido_db_user         => $ido_db_user,
        web_db              => 'pgsql',
        web_db_port         => '5432',
        web_db_name         => $web_db_name,
        web_db_pass         => $web_db_pass,
        web_db_user         => $web_db_user,
        require             => Postgresql::Server::Db["$web_db_name"],
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
