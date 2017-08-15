[![Build Status](https://travis-ci.org/Icinga/puppet-icingaweb2.png?branch=master)](https://travis-ci.org/Icinga/puppet-icingaweb2)

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

* [puppetlabs/stdlib] >= 4.16.0
* [puppetlabs/vcsrepo] >= 1.3.0
* [puppetlabs/concat] >= 2.0.1

Depending on your setup following modules may also be required:

* [puppetlabs/apt] >= 2.0.0
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
}

class { '::icinga2':
  manage_package => false,
}
```

Be careful with this option: Setting `manage_package` to false also means that this module will not install any
dependent packages of modules.

Use the [monitoring](#monitoring) class to connect the web interface to Icinga 2.

### Manage Resources
Icinga Web 2 resources are managed with the `icingaweb2::config::resource` defined type. Supported resource types
are `db` and `ldap`. Resources are used for the internal authentication mechanism and by modules. Depending on the type
of resource you are managing, different parameters may be required.

Create a `db` resource:

``` puppet
icingaweb2::config::resource{'my-sql':
  type        => 'db',
  db_type     => 'mysql',
  host        => 'localhost',
  port        => '3306',
  db_name     => 'icingaweb2',
  db_username => 'root',
  db_password => 'supersecret',
}
```

Create a `ldap` resource:

``` puppet
icingaweb2::config::resource{'my-ldap':
  type         => 'ldap',
  host         => 'localhost',
  port         => 389,
  ldap_root_dn => 'dc=users,dc=icinga,dc=com',
  ldap_bind_dn => 'cn=root,dc=users,dc=icinga,dc=com',
  ldap_bind_pw => 'supersecret',
}
```

### Manage Authentication Methods
Authentication methods are created with the `icingaweb2::config:authmethod` defined type. Various authentication methods
are supported: `db`, `ldap`, `msldap` and `external`. Auth methods can be chained with the `order` parameter.

Create a MySQL authmethod:

``` puppet
icingaweb2::config::resource{'my-sql':
  type        => 'db',
  db_type     => 'mysql',
  host        => 'localhost',
  port        => '3306',
  db_name     => 'icingaweb2',
  db_username => 'root',
  db_password => 'supersecret',
}
```

#### DB Schema and Default User
You can choose to import the database schema for MySQL or PostgreSQL. If you set `import_schema` to `true` the module
import the corresponding schema for your `db_type`. Additionally a resource, an authentication method and a role will be
generated.

The module does not support the creation of databases, we encourage you to use either the [puppetlabs/mysql] or the
[puppetlabs/puppetlabs-postgresql] module.

:bulb: Default credentials are: **User:** `icinga` **Password**: `icinga`

##### MySQL
Use MySQL as backend for user authentication in Icinga Web 2:

``` puppet
include ::mysql::server

mysql::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => 'icingaweb2',
  host     => 'localhost',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER'],
}

class {'icingaweb2':
  manage_repo   => true,
  import_schema => true,
  db_type       => 'pgsql',
  db_host       => 'localhost',
  db_port       => '5432',
  db_username   => 'icingaweb2',
  db_password   => 'icingaweb2',
  require       => Mysql::Db['icingaweb2'],
}
```

##### PostgreSQL
Use PostgreSQL as backend for user authentication in Icinga Web 2:

``` puppet
include ::postgresql::server

postgresql::server::db { 'icingaweb2':
  user     => 'icingaweb2',
  password => postgresql_password('icingaweb2', 'icingaweb2'),
}

class {'icingaweb2':
  manage_repo   => true,
  import_schema => true,
  db_type       => 'pgsql',
  db_host       => 'localhost',
  db_port       => '5432',
  db_username   => 'icingaweb2',
  db_password   => 'icingaweb2',
  require       => Postgresql::Server::Db['icingaweb2'],
}
```

#### Manage Roles
Roles are a set of permissions applied to users and groups. With filters you can limit the access to certain objects
only. Each module can add its own permissions, so it's hard to create a list of all available permissions. The following
permissions are included when the `monitoring` module is enabled:

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

With the monitoring module, possible filters are:
* `application/share/users`
* `application/share/groups`
* `monitoring/filter/objects`
* `monitoring/blacklist/properties`

Create role that allows a user to see only hosts beginning with `linux-*`:

``` puppet
icingaweb2::config::role{'linux-user':
  users       => 'bob, pete',
  permissions => '*',
  filters     => {
    'monitoring/filter/objects' => 'host_name=linux-*',
  }
}
```

#### Manage Group Backends
Group backends store information about available groups and their members. Valid backends are `db`, `ldap` or `msldap`.
Groups backends can be combined with authentication methods. For example, users can be stored in a database, but group
definitions in LDAP. If a user is member of multiple groups, he inherits permissions of all his groups.

Create an LDAP group backend:

``` puppet
icingaweb2::config::groupbackend {'ldap-backend':
  backend                     => 'ldap',
  resource                    => 'my-ldap',
  ldap_group_class            => 'groupofnames',
  ldap_group_name_attribute   => 'cn',
  ldap_group_member_attribute => 'member',
  ldap_base_dn                => 'ou=groups,dc=icinga,dc=com'
}
```

If you have imported the database schema (parameter `import_schema`), you can use this database as group backend:

``` puppet
icingaweb2::config::groupbackend {'mysql-backend':
  backend  => 'db',
  resource => 'mysql-icingaweb2',
}
```

### Install and Manage Modules

#### Monitoring
This module is mandatory for almost every setup. It connects your Icinga Web interface to the Icinga 2 core. Current and
history information are queried through the IDO database. Actions such as `Check Now`, `Set Downtime` or `Acknowledge`
are send to the Icinga 2 API.

Requirements: 

* IDO feature in Icinga 2 (MySQL or PostgreSQL)
* `ApiUser` object in Icinga 2 with proper permissions

Example:
``` puppet
class {'icingaweb2::module::monitoring':
  ido_host        => 'localhost',
  ido_db_name     => 'icinga2',
  ido_db_username => 'icinga2',
  ido_db_password => 'supersecret',
  api_username    => 'icinga',
  api_password    => 'root',
}
```

#### Director

#### Business Process

#### Cube 

## Reference

- [**Public classes**](#public-classes)
    - [Class: icingaweb2](#class-icingaweb2)
    - [Class: icingaweb2::module::monitoring](#class-icingaweb2modulemonitoring)
- [**Private classes**](#private-classes)
    - [Class: icingaweb2::config](#class-icingaweb2config)
    - [Class: icingaweb2::install](#class-icingaweb2install)
    - [Class: icingaweb2::params](#class-icingaweb2params)
    - [Class: icingaweb2::repo](#class-icingaweb2repo)
- [**Public defined types**](#public-defined-types)
    - [Defined type: icingaweb2::inisection](#defined-type-icingaweb2inisection)
    - [Defined type: icingaweb2::config::resource](#defined-type-icingaweb2configresource)
    - [Defined type: icingaweb2::config::authmethod](#defined-type-icingaweb2configauthmethod)
    - [Defined type: icingaweb2::config::role](#defined-type-icingaweb2configrole)
    - [Defined type: icingaweb2::config::groupbackend](#defined-type-icingaweb2configgroupbackend)
    - [Defined type: icingaweb2::module](#defined-type-icingaweb2module)
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

#### Class: `icingaweb2::module::monitoring`
Manage the monitoring module. This module is mandatory for probably every setup.

##### `ensure`
Enable or disable module. Defaults to `present`

##### `pretected_customvars`
Custom variables in Icinga 2 may contain sensible information. Set patterns for custom variables that should be hidden
in the web interface. Defaults to `*pw*, *pass*, community`

##### `ido_type`
Type of your IDO database. Either `mysql` or `pgsql`. Defaults to `mysql`

##### `ido_host`
Hostname of the IDO database.

##### `ido_port`
Port of the IDO database. Defaults to `3306`

##### `ido_db_name`
Name of the IDO database.

##### `ido_db_username`
Username for IDO DB connection.

##### `ido_db_password`
Password for IDO DB connection.

##### `api_host`
The API host is your Icinga 2.

##### `api_port`
Port of your Icinga 2 API. Defaults to `5665`

##### `api_username`
API username. This is needed to send commands to the Icinga 2 core Make sure you have a proper `ApiUser` configuration
object configured in Icinga 2.

##### `api_password`
Password of the API user.

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

#### Defined type: `icingaweb2::inisection`
Manage settings in INI configuration files.

**Parameters of `icingaweb2::inisection`:**

##### `section_name`
Name of the target section. Settings are set under `[$section_name]`

##### `target`
Absolute path to the configuration file.

##### `settings`
A hash of settings and their settings. Single settings may be set to absent.

##### `order`
Ordering of the INI section within a file. Defaults to `01`

#### Defined type: `icingaweb2::config::resource`
Manage settings in INI configuration files.

**Parameters of `icingaweb2::config::resource`:**

##### `resource_name`
Name of the resources. Resources are referenced by their name in other configuration sections.

##### `type`
Supported resource types are `db` and `ldap`.

##### `host`
Connect to the database or ldap server on the given host. For using unix domain sockets, specify `localhost` for MySQL
and the path to the unix domain socket directory for PostgreSQL. When using the 'ldap' type you can also provide
multiple hosts separated by a space.

##### `port`
Port number to use.

##### `db_type`
Supported DB types are `mysql` and `pgsql`. Only valid when `type` is `db`.

##### `db_name`
The database to use. Only valid if `type` is `db`.

##### `db_username`
The username to use when connecting to the server. Only valid if `type` is `db`.

##### `db_password`
The password to use when connecting to the server. Only valid if `type` is `db`.

##### `db_charset`
The character set to use for the database connection. Only valid if `type` is `db`.

##### `ldap_root_dn`
Root object of the tree, e.g. `ou=people,dc=icinga,dc=com`. Only valid if `type` is `ldap`.

##### `ldap_bind_dn`
The user to use when connecting to the server. Only valid if `type` is `ldap`.

##### `ldap_bind_pw`
The password to use when connecting to the server. Only valid if `type` is `ldap`.

##### `ldap_encryption`
Type of encryption to use: `none` (default), `starttls`, `ldaps`. Only valid if `type` is `ldap`.

#### Defined type: `icingaweb2::config::authmethod`
Manage Icinga Web 2 authentication methods. Auth methods may be chained by setting proper ordering. Some backends
require additional resources.

**Parameters of `icingaweb2::config::authmethod`:**

##### `backend`
Select between 'external', 'ldap', 'msldap' or 'db'. Each backend may require other settings.

##### `resource`
The name of the resource defined in resources.ini.

##### `ldap_user_class`
LDAP user class. Only valid if `backend` is `ldap`.

##### `ldap_user_name_attribute`
LDAP attribute which contains the username. Only valid if `backend` is `ldap`.

##### `ldap_filter`
LDAP search filter. Only valid if `backend` is `ldap`.

##### `order`
Multiple authentication methods can be chained. The order of entries in the authentication configuration determines
the order of the authentication methods. Defaults to `01`

#### Defined type: `icingaweb2::config::role`
Roles define a set of permissions that may be applied to users or groups.

**Parameters of `icingaweb2::config::role`:**

##### `role_name`
Name of the role.

##### `users`
Comma separated list of users this role applies to.

##### `groups`
Comma separated list of groups this role applies to.

##### `permissions`
Comma separated lsit of permissions. Each module may add it's own permissions. Examples are

* Allow everything: `*`
* Allow config access: `config/*`
* Allow access do module monitoring: `module/monitoring`
* Allow scheduling checks: `monitoring/command/schedule-checks`
* Grant admin permissions: `admin`

##### `filters`
Hash of filters. Modules may add new filter keys, some sample keys are:

* `application/share/users`
* `application/share/groups`
* `monitoring/filter/objects`
* `monitoring/blacklist/properties`

A string value is expected for each used key. For example:
* monitoring/filter/objects = `host_name!=*win*`

#### Defined type: `icingaweb2::config::groupbackend`
Groups of users can be stored either in a database, LDAP or ActiveDirectory. This defined type configures backends that
store groups.

**Parameters of `icingaweb2::config::groupbackend`:**

##### `group_name`
Name of the resources. Resources are referenced by their name in other configuration sections.

##### `backend`
Type of backend. Valide values are: `db`, `ldap` and `msldap`. Each backend supports different settings, see the
parameters for detailed information.

##### `resource`
The resource used to connect to the backend. The resource contains connection information.

##### `ldap_user_backend`
A group backend can be connected with an authentication method. This parameter references the auth method. Only
valid with backend `ldap` or `msldap`.

##### `ldap_group_class`
Class used to identify group objects. Only valid with backend `ldap`.

##### `ldap_group_filter`
Use a LDAP filter to receive only certain groups. Only valid with backend `ldap` or `msldap`.

##### `ldap_group_name_attribute`
The group name attribute. Only valid with backend `ldap`.

##### `ldap_group_member_attribute`
The group member attribute. Only valid with backend `ldap`.

##### `ldap_base_dn`
Base DN that is searched for groups. Only valid with backend `ldap` with `msldap`.

##### `ldap_nested_group_search`
Search for groups in groups. Only valid with backend `msldap`.

#### Defined type: `icingaweb2::module`
Download, enable and configure Icinga Web 2 modules. This is a public defined type and is meant to be used to install
modules developed by the community as well.

**Parameters of `icingaweb2::module`:**

##### `ensure`
Enable or disable module. Defaults to `present`

##### `module`
Name of the module.

##### `install_method`
Currently only `git` is supported as installation method. Other methods, such as `package`, may follow in future
releases.

##### `module_dir`
Target directory of the module. This setting is only valid in combination with the installation method `git`.

##### `git_repository`
Git repository of the module. This setting is only valid in combination with the installation method `git`.

##### `git_revision`
Tag or branch of the git repository. This setting is only valid in combination with the installation method `git`.

##### `settings`
A hash with the module settings. Multiple configuration files with ini sections can be configured with this hash. The
`module_name` should be used as target directory for the configuration files.

Example:

``` puppet 
 $conf_dir        = $::icingaweb2::params::conf_dir
 $module_conf_dir = "${conf_dir}/modules/mymodule"

 $settings = {
   'section1' => {
     'target'   => "${module_conf_dir}/config1.ini",
     'settings' => {
       'setting1' => 'value1',
       'setting2' => 'value2',
     }
   },
   'section2' => {
     'target'   => "${module_conf_dir}/config2.ini",
     'settings' => {
       'setting3' => 'value3',
       'setting4' => 'value4',
     }
   }
 }
```

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