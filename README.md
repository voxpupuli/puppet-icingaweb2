puppet-icingaweb2
==========

Table of Contents
-----------------

1. [Overview - What is the Icinga Web 2 module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with the Icinga 2 module](#setup)
4. [Usage - How to use the module for various tasks](#usage)
    * [Object type usage](#object_type_usage)
    * [Objects](#objects)
5. [Reference - The classes and defined types available in this module](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Contributors - List of module contributors](#contributors)

[Overview](id:overview)
--------

> **Note**
>
> Work in progress!

This module installs and configures the [Icinga Web 2 user interace](https://www.icinga.org).

[Module Description](id:module-description)
-------------------

Coming soon...

[Setup](id:setup)
-----

This module should be used with Puppet 3.6 or later. It may work with earlier versions of Puppet 3 but it has not been tested.

This module requires Facter 2.2 or later, specifically because it uses the `operatingsystemmajrelease` fact.

This module requires the [Puppet Labs stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib).

###Server requirements

Icinga Web 2 requires either a [MySQL](http://www.mysql.com/) or a [Postgres](http://www.postgresql.org/) database.

Currently, this module does not set up any databases. You'll have to create one before installing Icinga 2 via the module.

[Usage](id:usage)
-----

###General Usage

> **Note**
>
> Work in progress!

[Reference](id:reference)
---------

Classes:

Coming soon...

Defined types:

Coming soon...

[Limitations](id:limitations)
------------

Coming soon...

[Development](id:contributors)
------------

###Contributing

To submit a pull request via Github, fork [Icinga/puppet-icinga2](https://github.com/Icinga/puppet-icinga2) and make your changes in a feature branch off of the **develop** branch.

If your changes require any discussion, create an account on [https://www.icinga.org/register/](https://www.icinga.org/register/). Once you have an account, log onto [dev.icinga.org](https://dev.icinga.org/). Create an issue under the **Icinga Tools** project and add it to the **Puppet** category.

If applicable for the changes you're making, add documentation to the `README.md` file.

###Support

Check the project website at http://www.icinga.org for status updates and
https://support.icinga.org if you want to contact us.

[Contributors](id:contributors)
------------

Coming soon...
