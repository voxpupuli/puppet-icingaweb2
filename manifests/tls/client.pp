# @summary
#   A class to generate tls key, cert and cacert paths.
#
# @api private
#
# @param args
#   A config hash with the keys:
#   key_file, cert_file, cacert_file, key, cert and cacert
#
define icingaweb2::tls::client(
  Hash[String, Any] $args,
) {

  assert_private()

  $owner = $::icingaweb2::conf_user
  $group = $::icingaweb2::conf_group

  File {
    owner => $owner,
    group => $group,
    mode  => '0640',
  }

  if $args[key] {
    file { $args['key_file']:
      ensure    => file,
      content   => icingaweb2::unwrap($args['key']),
      mode      => '0400',
      show_diff => false,
    }
  }

  if $args['cert'] {
    file { $args['cert_file']:
      ensure  => file,
      content => $args['cert'],
    }
  }

  if $args['cacert'] {
    file { $args['cacert_file']:
      ensure  => file,
      content => $args['cacert'],
    }
  }
}
