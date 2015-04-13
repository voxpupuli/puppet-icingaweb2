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

### Usage
```
  class {
    '::icingaweb2':
      manage_repo     => false,
      install_method  => 'package',
      auth_backend    => 'ldap',
      modules_enabled => [ 'doc', 'monitoring', 'setup', 'translation' ]
  }
```
  Note: This both Databaseschema must be exists!
```
  class {
    'icingaweb2::config::database::ido':
      db_type          => 'mysql',
      db_username      => $ide_db_username',
      db_password      => $ido_db_password,
      db_schema        => $ido_db_name,
  }
```
  class {
    'icingaweb2::config::database::web':
      db_type          => 'mysql',
      db_username      => $web_db_user,
      db_password      => $web_db_pass,
      db_schema        => $web_db_name,
      db_prefix        => $web_db_prefix,
  }
```
  LDAP Configuration
```
  class {
    'icingaweb2::config::auth::ldap':
      # Auth
      base_dn          => $ldap_base_dn,
      user_class       => $ldap_user_class,
      user_name_attr   => $ldap_user_name_attr,
      # resource
      hostname         => $ldap_host,
      port             => $ldap_port,
      bind_dn          => $ldap_bind_dn,
      bind_pw          => $ldap_bind_pw,
      root_dn          => $ldap_root_dn,
      connection       => $ldap_connection,
  }

  class {
    'icingaweb2::config::resources::livestatus':
      socket   => '/var/run/icinga2/cmd/livestatus'
  }

  class {
    'icingaweb2::module::monitoring':
      enabled          => true,
      backend_type     => 'ido',
      backend_resource => 'icinga_ido'
  }
```

## Contributing

* Fork it
* Create a feature branch (`git checkout -b my-new-feature`)
* Run rspec tests (`bundle exec rake spec`)
* Commit your changes (`git commit -am 'Added some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create new Pull Request
