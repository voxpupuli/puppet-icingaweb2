# == Define: icingaweb2::module::puppetdb
#
# Install and configure the puppetdb module.  It is possible to let the module
# to configure the ssl certificates to connect to one or more PuppetDBs.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
# [*git_repository*]
#   Set a git repository URL. Defaults to github.
#
# [*git_revision*]
#   Set either a branch or a tag name, eg. `master` or `v1.3.2`.
#
# [*ssl*]
#   How to set up ssl certificates. To copy certificates from the local puppet installation, use `puppet`. Defaults to
#   `none`
#
# [*certificates*]
#   Hash with icingaweb2::module::puppetdb::monitoring resources.
#
class icingaweb2::module::puppetdb(
  $ensure         = 'present',
  $git_repository = 'https://github.com/Icinga/icingaweb2-module-puppetdb.git',
  $git_revision   = undef,
  $ssl            = 'none',
  $certificates   = undef,
){
  $conf_dir   = "${::icingaweb2::params::conf_dir}/modules/puppetdb"
  $ssl_dir    = "${conf_dir}/ssl"
  $conf_user  = $::icingaweb2::params::conf_user
  $conf_group = $::icingaweb2::params::conf_group

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_string($git_repository)
  validate_string($git_revision)
  validate_re($ssl, [ '^none$', '^puppet$' ],
    "${ssl} isn't supported. Valid values are 'none' and 'puppet'.")

  file { $ssl_dir:
    ensure  => 'directory',
    group   => $conf_group,
    owner   => $conf_user,
    mode    => '2740',
    purge   => true,
    force   => true,
    recurse => true,
  }

  # handle the certificate's stuff
  case $ssl {
    'puppet': {

      $my_certname     = $::fqdn
      $puppetdb_ssldir = "${ssl_dir}/puppetdb"

      file { [$puppetdb_ssldir, "${puppetdb_ssldir}/private_keys", "${puppetdb_ssldir}/certs"]:
        ensure  => 'directory',
        group   => $conf_group,
        owner   => $conf_user,
        mode    => '2740',
        purge   => true,
        force   => true,
        recurse => true,
      }

      file { "${puppetdb_ssldir}/certs/ca.pem":
        ensure => 'present',
        group  => $conf_group,
        owner  => $conf_user,
        mode   => '0640',
        source => "${::settings::ssldir}/certs/ca.pem",
      }

      # Combined SSL key path (private+public key)
      $combinedkey_path = "${puppetdb_ssldir}/private_keys/puppetdb_combined.pem"
      concat { $combinedkey_path:
        ensure         => present,
        warn           => false,
        owner          => $conf_user,
        group          => $conf_group,
        mode           => '0640',
        ensure_newline => true,
      }

      concat::fragment { 'private_key':
        target => $combinedkey_path,
        source => "${::settings::ssldir}/private_keys/${my_certname}.pem",
        order  => 1,
      }

      concat::fragment { 'public_key':
        target => $combinedkey_path,
        source => "${::settings::ssldir}/certs/${my_certname}.pem",
        order  => 2,
      }

    } # puppet
    'none': { }
    default: { }
  } # case ssl

  if $certificates {
    validate_hash($certificates)
    create_resources('icingaweb2::module::puppetdb::certificate',$certificates)
  }

  icingaweb2::module {'puppetdb':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }
}
