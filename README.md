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

Depending on your setup following modules may also be required:

* [puppetlabs/apt](https://forge.puppet.com/puppetlabs/apt) >= 1.8.0
* [darin/zypprepo](https://forge.puppet.com/darin/zypprepo) >= 1.0.2

### Limitations

This module has been tested on:

* Debian 7, 8
* CentOS/RHEL 6, 7
* Ubuntu 14.04, 16.04
* SLES 12

Other operating systems or versions may work but have not been tested.

## Usage

### Install Icinga Web 2

The default class `icingaweb2` installs a basic installation of Icinga Web 2 by using the systems package manager. It
is recommended to use the official Icinga repository for the installation.

Use the `manage_repo` parameter to configure the official [packages.icinga.com](https://packages.icinga.com)
repository.

``` puppet
class { '::icingaweb2':
  manage_repo => true,
}
```

If you want to manage the version of Icinga Web 2, you have to disable the package management of this module and handle
packages in your own Puppet code.

``` puppet
package { 'icinga2':
  ensure => latest,
  notifiy => Class['icinga2'],
}

class { '::icinga2':
  manage_package => false,
}
```

Be careful with this option: Setting `manage_package` to false also means that this module will not install any dependent
packages of modules.

#### Install and Manage Modules

##### Monitoring

##### Director

##### Business Process

##### Cube 

## Reference

- [**Public classes**](#public-classes)
    - [Class: icingaweb2](#class-icingaweb2)
    - [Class: icingaweb2::mod::monitoring](#class-icingaweb2modmonitoring)
    - [Class: icingaweb2::mod::businessprocess](#class-icingaweb2modbusinessprocess)
- [**Private classes**](#private-classes)
    - [Class: icingaweb2::config](#class-icingaweb2config)
    - [Class: icingaweb2::install](#class-icingaweb2install)
    - [Class: icingaweb2::params](#class-icingaweb2params)
    - [Class: icingaweb2::repo](#class-icingaweb2repo)
    - [Class: icingaweb2::initialize](#class-icingaweb2initialize)
- [**Public defined types**](#public-defined-types)
    - [Defined type: icingaweb2::config::authentication_database](#defined-type-icingaweb2::config::authentication_database)
    - [Defined type: icingaweb2::config::authentication_external](#defined-type-icingaweb2::config::authentication_external)
    - [Defined type: icingaweb2::config::authentication_ldap](#defined-type-icingaweb2::config::authentication_ldap)
    - [Defined type: icingaweb2::config::resource_database](#defined-type-icingaweb2::config::resource_database)
    - [Defined type: icingaweb2::config::resource_file](#defined-type-icingaweb2::config::resource_file)
    - [Defined type: icingaweb2::config::resource_ldap](#defined-type-icingaweb2::config::resource_ldap)
    - [Defined type: icingaweb2::config::resource_livestatus](#defined-type-icingaweb2::config::resource_livestatus)
    - [Defined type: icingaweb2::config::roles](#defined-type-icingaweb2::config::roles)
- [**Private defined types**](#private-defined-types)

### Public Classes

#### Class: `icingaweb2`
The default class of this module. It handles the basic installation and configuration of Icinga Web 2. 

**Parameters of `icingaweb2`:**

##### `manage_repo`
When set to true this module will install the packages.icinga.com repository. With this official repo you can get the
latest version of Icinga Web. When set to false the operating systems default will be used. Defaults to `false`

**NOTE**: will be ignored if manage_package is set to `false`

##### `manage_package`
If set to false packages aren't managed. Defaults to `true`

#### Class: `icingaweb2::mod::monitoring`

**Parameters of `icingaweb2::mod::monitoring`:**

#### Class: `icingaweb2::mod::businessprocess`

**Parameters of `icingaweb2::mod:businessprocess`:**

### Private Classes

#### Class: `icingaweb2::config`

**Parameters of `icingaweb2::config`:**

#### Class: `icingaweb2::install`

**Parameters of `icingaweb2::install`:**

#### Class: `icingaweb2::params`

**Parameters of `icingaweb2::params`:**

#### Class: `icingaweb2::repo`

**Parameters of `icingaweb2::repo`:**

#### Class: `icingaweb2::initialize`

**Parameters of `icingaweb2::initialize`:**

### Public Defined Types

#### Defined type: `icingaweb2::config::authentication_database`

**Parameters of `icingaweb2::config::authentication_database`:**

#### Defined type: `icingaweb2::config::authentication_external`

**Parameters of `icingaweb2::config::authentication_external`:**

#### Defined type: `icingaweb2::config::authentication_ldap`

**Parameters of `icingaweb2::config::authentication_ldap`:**

#### Defined type: `icingaweb2::config::resource_database`

**Parameters of `icingaweb2::config::resource_database`:**

#### Defined type: `icingaweb2::config::resource_file`

**Parameters of `icingaweb2::config::resource_file`:**

#### Defined type: `icingaweb2::config::resource_ldap`

**Parameters of `icingaweb2::config::resource_ldap`:**

#### Defined type: `icingaweb2::config::resource_livestatus`

**Parameters of `icingaweb2::config::resource_livestatus`:**

#### Defined type: `icingaweb2::config::roles`

**Parameters of `icingaweb2::config::roles`:**

### Private Defined Types

## Development
A roadmap of this project is located at https://github.com/Icinga/puppet-icingaweb2/milestones. Please consider
this roadmap when you start contributing to the project.

### Contributing
When contributing several steps such as pull requests and proper testing implementations are required.
Find a detailed step by step guide in [CONTRIBUTING.md].

### Testing
Testing is essential in our workflow to ensure a good quality. We use RSpec as well as Serverspec to test all components
of this module. For a detailed description see [TESTING.md].

## Release Notes
When releasing new versions we refer to [SemVer 1.0.0] for version numbers. All steps required when creating a new
release are described in [RELEASE.md]

See also [CHANGELOG.md]

## Authors
[AUTHORS] is generated on each release.
