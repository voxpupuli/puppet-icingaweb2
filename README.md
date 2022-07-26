[![Build Status](https://travis-ci.org/Icinga/puppet-icingaweb2.png?branch=master)](https://travis-ci.org/Icinga/puppet-icingaweb2)

# Icinga Web 2 Puppet Module

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with Icinga Web 2](#setup)
    * [What Icinga Web 2 affects](#what-icinga-web-2-affects)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference](#reference)
6. [Development - Guide for contributing to the module](#development)

## Overview

[Icinga Web 2] is the associated web interface for the open source
monitoring tool [Icinga 2]. This module helps with installing and managing
configuration of Icinga Web 2 and its modules on multiple operating systems.

### Description

This module installs and configures Icinga Web 2 on your Linux host by using the official packages from
[packages.icinga.com]. Dependend packages are installed as they are defined in the Icinga Web 2 package.

This module can manage all configurations files of Icinga Web 2 and import an initial database schema. It can install and
manage all official [modules](https://www.icinga.com/products/icinga-web-2-modules/) as well as modules developed by the
community.

### What's new in version 3.0.0

* The current version now uses the `icinga::repos` class from the new module `icinga` for the configuration of
repositories including EPEL on RedHat and Backports on Debian. (see https://github.com/icinga/puppet-icinga)

## Setup

### What the Icinga 2 Puppet module supports

* Installation of Icinga Web 2 via packages
* Configuration
* MySQL / PostgreSQL database schema import
* Install and manage official Icinga Web 2 modules
* Install community modules

### Dependencies

This module depends on

* [icinga/icinga] >= 1.0.0
    * needed if `manage_repos` is set to `true`
* [puppetlabs/stdlib] >= 4.25.0
* [puppetlabs/vcsrepo] >= 1.3.0
* [puppetlabs/concat] >= 2.0.1

### Limitations

This module has been tested on:

* Debian 9, 10, 11
* CentOS/RHEL 7
  * Requires [Software Collections Repository](https://wiki.centos.org/AdditionalResources/Repositories/SCL)
* RHEL/AlmaLinux/Rocky 8
  * Requires an [Icinga Subscription](https://icinga.com/subscription) for all versions >= 2.9.5 of Icinga Web 2.
* Ubuntu 16.04, 18.04, 20.04
* SLES 12, 15

Other operating systems or versions may work but have not been tested.

## Usage

NOTE: If you plan to use additional modules from git, the CLI `git` command has to be installed. You can manage it yourself as package resource or declare the package name in `extra_packages`.

By default, your distribution's packages are used to install Icinga Web 2.

Use the `manage_repos` parameter to configure repositories by default the official and stable [packages.icinga.com]. To configure your own
repositories, or use the official testing or nightly snapshot stage, see https://github.com/icinga/puppet-icinga.

``` puppet
class { '::icingaweb2':
  manage_repos => true,
}
```

The usage of this module isn't simple. That depends on how Icinga Web 2 is implemented. Monitoring is here just a module in a framework. All basic stuff like authentication, logging or authorization is done by this framework. To store user and usergroups in a MySQL database, the database has to exist:
```
mysql::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => 'supersecret',
  host     => 'localhost',
  grant    => [ 'ALL' ],
}

class {'icingaweb2':
  manage_repos   => true,
  import_schema  => true,
  db_type        => 'mysql',
  db_host        => 'localhost',
  db_port        => 3306,
  db_username    => 'icingaweb2',
  db_password    => 'supersecret',
  config_backend => 'db',
  extra_packages => [ 'git' ],
  require        => Mysql::Db['icingaweb2'],
}
```
If you set `import_schema` to `true` an default admin user `icingaadmin` with password `icinga` will be created automatically and you're allowed to login.

In case that `import_schema` is disabled or you'd like to use a different backend for authorization like LDAP, more work is required. At first we need a ressource with credentials to connect a LDAP server:
```
class {'icingaweb2':
  manage_repos   => true,
}

icingaweb2::config::resource{ 'my-ldap':
  type         => 'ldap',
  host         => 'localhost',
  port         => 389,
  ldap_root_dn => 'ou=users,dc=icinga,dc=com',
  ldap_bind_dn => 'cn=icingaweb2,ou=users,dc=icinga,dc=com',
  ldap_bind_pw => 'supersecret',
}
```
With the help of this resource, we are now creating user and group backends. Users are permitted to login and users and groups will later be used for authorization.
```
icingaweb2::config::authmethod { 'ldap-auth':
  backend                  => 'ldap',
  resource                 => 'my-ldap',
  ldap_user_class          => 'user',
  ldap_filter              => '(memberof:1.2.840.113556.1.4.1941:=CN=monitoring,OU=groups,DC=icinga,DC=com)',
  ldap_user_name_attribute => 'cn',
  order                    => '05',
}

icingaweb2::config::groupbackend { 'ldap-groups':
  backend                     => 'ldap',
  resource                    => 'my-ldap',
  ldap_group_class            => 'group',
  ldap_group_name_attribute   => 'cn',
  ldap_group_member_attribute => 'member',
  ldap_base_dn                => 'ou=groups,dc=icinga,dc=com',
  domain                      => 'icinga.com',
}
```
So that a group gets admin rights a role has to manage:
```
icingaweb2::config::role { 'default admin user':
  groups      => 'icingaadmins',
  permissions => '*',
}
```
All available permissions for module monitoring are listed below:
| Description | Value |
|-------------|-------|
| Allow everything | `*` |
| Allow to share navigation items | `application/share/navigation` |
| Allow to adjust in the preferences whether to show stacktraces | `application/stacktraces` |
| Allow to view the application log | `application/log` |
| Grant admin permissions, e.g. manage announcements | `admin` |
| Allow config access | `config/*` |
| Allow access to module doc | `module/doc` |
| Allow access to module monitoring | `module/monitoring` |
| Allow all commands | `monitoring/command/*` |
| Allow scheduling host and service checks | `monitoring/command/schedule-check` |
| Allow acknowledging host and service problems | `monitoring/command/acknowledge-problem` |
| Allow removing problem acknowledgements | `monitoring/command/remove-acknowledgement` |
| Allow adding and deleting host and service comments | `monitoring/command/comment/*` |
| Allow commenting on hosts and services | `monitoring/command/comment/add` |
| Allow deleting host and service comments | `monitoring/command/comment/delete` |
| Allow scheduling and deleting host and service downtimes | `monitoring/command/downtime/*` |
| Allow scheduling host and service downtimes | `monitoring/command/downtime/schedule` |
| Allow deleting host and service downtimes | `monitoring/command/downtime/delete` |
| Allow processing host and service check results | `monitoring/command/process-check-result` |
| Allow processing commands for toggling features on an instance-wide basis | `monitoring/command/feature/instance` |
| Allow processing commands for toggling features on host and service objects | `monitoring/command/feature/object/*`) |
| Allow processing commands for toggling active checks on host and service objects | `monitoring/command/feature/object/active-checks` |
| Allow processing commands for toggling passive checks on host and service objects | `monitoring/command/feature/object/passive-checks` |
| Allow processing commands for toggling notifications on host and service objects | `monitoring/command/feature/object/notifications` |
| Allow processing commands for toggling event handlers on host and service objects | `monitoring/command/feature/object/event-handler` |
| Allow processing commands for toggling flap detection on host and service objects | `monitoring/command/feature/object/flap-detection` |
| Allow sending custom notifications for hosts and services | `monitoring/command/send-custom-notification` |
| Allow access to module setup | `module/setup` |
| Allow access to module test | `module/test` |
| Allow access to module translation | `module/translation` |

Finally we configure the monitoring with the needed connection to the IDO to get information and an API user to send commands to Icinga 2:
```
class {'icingaweb2::module::monitoring':
  ido_host        => 'localhost',
  ido_db_type     => 'mysql',
  ido_db_name     => 'icinga2',
  ido_db_username => 'icinga2',
  ido_db_password => 'supersecret',
  commandtransports => {
    icinga2 => {
      transport => 'api',
      username  => 'icingaweb2',
      password  => 'supersecret',
    }
  }
}
```

## Reference

See [REFERENCE.md](https://github.com/Icinga/puppet-icingaweb2/blob/master/REFERENCE.md)

## Development

A roadmap of this project is located at https://github.com/Icinga/puppet-icingaweb2/milestones. Please consider
this roadmap when you start contributing to the project.

### Contributing

When contributing several steps such as pull requests and proper testing implementations are required.
Find a detailed step by step guide in [CONTRIBUTING.md].

### Testing

Testing is essential in our workflow to ensure a good quality. We use RSpec as well as Serverspec to test all components
of this module. For a detailed description see [TESTING.md].

### Release Notes

When releasing new versions we refer to [SemVer 1.0.0] for version numbers. All steps required when creating a new
release are described in [RELEASE.md]

See also [CHANGELOG.md]

### Authors

[AUTHORS] is generated on each release.


[Icinga 2]: https://www.icinga.com/products/icinga-2/
[Icinga Web 2]: https://www.icinga.com/products/icinga-web-2/
[icinga/icinga]: https://github.com/icinga/puppet-icinga/

[puppetlabs/stdlib]: https://github.com/puppetlabs/puppetlabs-stdlib
[puppetlabs/concat]: https://github.com/puppetlabs/puppetlabs-concat
[puppetlabs/vcsrepo]: https://forge.puppet.com/puppetlabs/vcsrepo
[puppetlabs/mysql]: https://github.com/puppetlabs/puppetlabs-mysql
[puppetlabs/puppetlabs-postgresql]: https://github.com/puppetlabs/puppetlabs-postgresql
[packages.icinga.com]: https://packages.icinga.com

[CHANGELOG.md]: CHANGELOG.md
[AUTHORS]: AUTHORS
[RELEASE.md]: RELEASE.md
[TESTING.md]: TESTING.md
[CONTRIBUTING.md]: CONTRIBUTING.md
