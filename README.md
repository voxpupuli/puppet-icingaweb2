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
[Icinga Web 2] is the associated web interface for the open source
monitoring tool [Icinga 2]. This module helps with installing and managing
configuration of Icinga Web 2 and its modules on multiple operating systems.

## Description

This module installs and configures Icinga Web 2 on your Linux host by using the official packages from
[packages.icinga.com]. Dependend packages are installed as they are defined in the Icinga Web 2 package.

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

* [puppetlabs/stdlib] >= 4.4.0
* [puppetlabs/vcsrepo] >= 1.2.0

Depending on your setup following modules may also be required:

* [puppetlabs/apt] >= 1.8.0
* [darin/zypprepo] >= 1.0.2

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

Use the `manage_repo` parameter to configure the official [packages.icinga.com] repository.

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
- [**Private classes**](#private-classes)
    - [Class: icingaweb2::config](#class-icingaweb2config)
    - [Class: icingaweb2::install](#class-icingaweb2install)
    - [Class: icingaweb2::params](#class-icingaweb2params)
    - [Class: icingaweb2::repo](#class-icingaweb2repo)
- [**Public defined types**](#public-defined-types)
    - [Defined type: icingaweb2::inifile](#defined-type-icingaweb2inifile)
- [**Private defined types**](#private-defined-types)

### Public Classes

#### Class: `icingaweb2`
The default class of this module. It handles the basic installation and configuration of Icinga Web 2. 

**Parameters of `icingaweb2`:**

##### `logging`
Whether Icinga Web 2 should log to `file` or to `syslog`. Setting `none` disables logging. Defaults to `file`

##### `logging_file`
If 'logging' is set to `file`, this is the target log file. Defaults to `/var/log/icingaweb2/icingaweb2.log`.

##### `logging_level`
Logging verbosity. Possible values are `ERROR`, `WARNING`, `INFO` and `DEBUG`. Defaults to `INFO`

##### `enable_stacktraces`
Whether to display stacktraces in the web interface or not. Defaults to `false`

##### `module_path`
Path to module sources. Multiple paths must be separated by colon. Defaults to `/usr/share/icingaweb2/modules`

##### `theme`
The default theme setting. Users may override this settings. Defaults to `icinga`.

##### `theme_access`
Whether users can change themes or not. Defaults to `true`.

##### `manage_repo`
When set to true this module will install the packages.icinga.com repository. With this official repo you can get the
latest version of Icinga Web. When set to false the operating systems default will be used. Defaults to `false`

**NOTE**: will be ignored if manage_package is set to `false`

##### `manage_package`
If set to false packages aren't managed. Defaults to `true`

### Private Classes

#### Class: `icingaweb2::config`
Installs basic configuration files required to run Icinga Web 2.

#### Class: `icingaweb2::install`
Handles the installation of the Icinga Web 2 package.

#### Class: `icingaweb2::params`
Stores all default parameters for the Icinga Web 2 installation.

#### Class: `icingaweb2::repo`
Installs the [packages.icinga.com] repository. Depending on your operating system [puppetlabs/apt] or
[darin/zypprepo] are required.

### Public Defined Types

#### Defined type: `icingaweb2::inifile`
Manage settings in INI configuration files.

**Parameters of `icingaweb2::inifile`:**

##### `ensure`
Set to present creates the configuration file, absent removes it. Defaults to present. Singhe settings may be set to 'absent' int he $settings parameter.

##### `target`
Absolute path to the configuration file.

##### `settings`
A hash of settings and their settings. Single settings may be set to absent.

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


[Icinga 2]: https://www.icinga.com/products/icinga-2/
[Icinga Web 2]: https://www.icinga.com/products/icinga-web-2/

[puppetlabs/apt]: https://github.com/puppetlabs/puppetlabs-apt
[darin/zypprepo]: https://forge.puppet.com/darin/zypprepo
[puppetlabs/stdlib]: https://github.com/puppetlabs/puppetlabs-stdlib
[packages.icinga.com]: https://packages.icinga.com

[CHANGELOG.md]: CHANGELOG.md
[AUTHORS]: AUTHORS
[RELEASE.md]: RELEASE.md
[TESTING.md]: TESTING.md
[CONTRIBUTING.md]: CONTRIBUTING.md