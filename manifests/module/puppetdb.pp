# @summary
# Installs and configures the puppetdb module.
#
# @note If you want to use `git` as `install_method`, the CLI `git` command has to be installed. You can manage it yourself as package resource or declare the package name in icingaweb2 class parameter `extra_packages`.
#
# @param ensure
#   Enable or disable module.
#
# @param module_dir
#   Target directory of the module.
#
# @param git_repository
#   Set a git repository URL.
#
# @param git_revision
#   Set either a branch or a tag name, eg. `master` or `v1.3.2`.
#
# @param install_method
#   Install methods are `git`, `package` and `none` is supported as installation method.
#
# @param package_name
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#
# @param ssl
#   How to set up ssl certificates. To copy certificates from the local puppet installation, use `puppet`.
#
# @param host
#   Hostname of the server where PuppetDB is running. The `ssl` parameter needs to be set to `puppet`.
#
# @param certificates
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
class icingaweb2::module::puppetdb (
  Enum['absent', 'present']      $ensure         = 'present',
  Optional[Stdlib::Absolutepath] $module_dir     = undef,
  String                         $git_repository = 'https://github.com/Icinga/icingaweb2-module-puppetdb.git',
  Optional[String]               $git_revision   = undef,
  Enum['git', 'none', 'package'] $install_method = 'git',
  String                         $package_name   = 'icingaweb2-module-puppetdb',
  Enum['none', 'puppet']         $ssl            = 'none',
  Optional[Stdlib::Host]         $host           = undef,
  Hash                           $certificates   = {},
) {
  $conf_dir   = "${icingaweb2::globals::conf_dir}/modules/puppetdb"
  $ssl_dir    = "${conf_dir}/ssl"
  $conf_user  = $icingaweb2::conf_user
  $conf_group = $icingaweb2::conf_group

  file { $ssl_dir:
    ensure  => directory,
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
        ensure  => directory,
        group   => $conf_group,
        owner   => $conf_user,
        mode    => '2740',
        purge   => true,
        force   => true,
        recurse => true,
      }

      file { "${puppetdb_ssldir}/certs/ca.pem":
        ensure => file,
        group  => $conf_group,
        owner  => $conf_user,
        mode   => '0640',
        source => "${settings::ssldir}/certs/ca.pem",
      }

      $combinedkey_path = "${puppetdb_ssldir}/private_keys/${facts['networking']['fqdn']}_combined.pem"

      notice($settings::ssldir)

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
        source => "${settings::ssldir}/private_keys/${facts['networking']['fqdn']}.pem",
        order  => 1,
      }

      concat::fragment { 'public_key':
        target => $combinedkey_path,
        source => "${settings::ssldir}/certs/${facts['networking']['fqdn']}.pem",
        order  => 2,
      }
    } # puppet
    'none': {}
    default: {}
  }

  create_resources('icingaweb2::module::puppetdb::certificate',$certificates)

  icingaweb2::module { 'puppetdb':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    module_dir     => $module_dir,
    package_name   => $package_name,
  }
}
