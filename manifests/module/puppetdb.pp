# @summary
# Installs and configures the puppetdb module.
#
# @param [Enum['absent', 'present']] ensure
#   Enable or disable module.
#
# @param [String] git_repository
#   Set a git repository URL.
#
# @param [Optional[String]] git_revision
#   Set either a branch or a tag name, eg. `master` or `v1.3.2`.
#
# @param [Enum['none', 'puppet']] ssl
#   How to set up ssl certificates. To copy certificates from the local puppet installation, use `puppet`.
#
# @param [Optional[Stdlib::Host]] host
#   Hostname of the server where PuppetDB is running. The `ssl` parameter needs to be set to `puppet`.
#
# @param [Hash] certificates
#   Hash with icingaweb2::module::puppetdb::certificate resources.
#
# @note The [PuppetDB module documentation](https://www.icinga.com/docs/director/latest/puppetdb/doc/01-Installation/).
#
# @example Set up the PuppetDB module and configure two custom SSL keys:
#   $certificates = {
#     'pupdb1' => {
#       :ssl_key => '-----BEGIN RSA PRIVATE KEY----- abc...',
#       :ssl_cacert => '-----BEGIN RSA PRIVATE KEY----- def...',
#      },
#     'pupdb2' => {
#       :ssl_key => '-----BEGIN RSA PRIVATE KEY----- zyx...',
#       :ssl_cacert => '-----BEGIN RSA PRIVATE KEY----- wvur...',
#     },
#   }
#   
#   class { '::icingaweb2::module::puppetdb':
#     git_revision => 'master',
#     ssl          => 'none',
#     certificates => $certificates,
#   }
#   
# @example Set up the PuppetDB module and configure the hosts SSL key to connect to the PuppetDB host:
#   class {'::icingaweb2::module::puppetdb':
#     git_revision => 'master',
#     ssl          => 'puppet',
#     host         => 'puppetdb.example.com',
#   }
#
class icingaweb2::module::puppetdb(
  String                    $git_repository,
  Enum['absent', 'present'] $ensure         = 'present',
  Optional[String]          $git_revision   = undef,
  Enum['none', 'puppet']    $ssl            = 'none',
  Optional[Stdlib::Host]    $host           = undef,
  Hash                      $certificates   = {},
){
  $conf_dir   = "${::icingaweb2::globals::conf_dir}/modules/puppetdb"
  $ssl_dir    = "${conf_dir}/ssl"
  $conf_user  = $::icingaweb2::conf_user
  $conf_group = $::icingaweb2::conf_group

  file { $ssl_dir:
    ensure  => 'directory',
    group   => $conf_group,
    owner   => $conf_user,
    mode    => '2740',
    purge   => true,
    force   => true,
    recurse => true,
  }

  case $ssl {
    'puppet': {

      $puppetdb_ssldir = "${ssl_dir}/${host}"

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

      $combinedkey_path = "${puppetdb_ssldir}/private_keys/${::fqdn}_combined.pem"

      notice("${::settings::ssldir}")

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
        source => "${::settings::ssldir}/private_keys/${::fqdn}.pem",
        order  => 1,
      }

      concat::fragment { 'public_key':
        target => $combinedkey_path,
        source => "${::settings::ssldir}/certs/${::fqdn}.pem",
        order  => 2,
      }

    } # puppet
    'none': { }
    default: { }
  } # case ssl

  create_resources('icingaweb2::module::puppetdb::certificate',$certificates)

  icingaweb2::module {'puppetdb':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }
}
