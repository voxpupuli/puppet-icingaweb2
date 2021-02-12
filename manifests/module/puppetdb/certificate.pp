# @summary
#   Installs a certificate for the Icinga Web 2 puppetdb module.
#
# @param [Enum['absent', 'present']] ensure
#   Enable or disable module. Defaults to `present`
#
# @param [String] ssl_key
#   The combined key in a base64 encoded string.
#
# @param [String] ssl_cacert
#   The CA root certificate in a base64 encoded string.
#
# @note It is advised to read first something about the certiciates in the [documentation](https://github.com/Icinga/icingaweb2-module-puppetdb/blob/master/doc/01-Installation.md).
#
# @example You can set up indiviual certificates for the Icinga Web 2 director puppetdb module to talk to you director like this:
#   icingaweb2::module::puppetdb::certificate { 'mypuppetdbhost.example.com':
#     ssl_cacert  => '-----BEGIN CERTIFICATE----- ...',
#     ssl_key     => '-----BEGIN RSA PRIVATE KEY----- ...',
#   }
#
# @api private
#
define icingaweb2::module::puppetdb::certificate(
  String                    $ssl_key,
  String                    $ssl_cacert,
  Enum['absent', 'present'] $ensure = 'present',
){
  assert_private("You're not supposed to use this defined type manually.")

  $certificate_dir = "${::icingaweb2::module::puppetdb::ssl_dir}/${title}"
  $conf_user       = $::icingaweb2::conf_user
  $conf_group      = $::icingaweb2::conf_group

  File {
    owner => $conf_user,
    group => $conf_group,
    mode  => '0740',
  }

  if $ensure == 'present' {
    $ensure_dir = 'directory'
  } else {
    $ensure_dir = 'absent'
  }

  file { [$certificate_dir, "${certificate_dir}/private_keys", "${certificate_dir}/certs"]:
    ensure  => $ensure_dir,
    purge   => true,
    force   => true,
    recurse => true,
  }

  file {"${certificate_dir}/private_keys/${title}_combined.pem":
    ensure  => $ensure,
    content => $ssl_key,
  }

  file {"${certificate_dir}/certs/ca.pem":
    ensure  => $ensure,
    content => $ssl_cacert,
  }

}
