# @summary
#   Choose the path of tls key, cert and ca file.
#
# @return
#    Returned hash includes all paths and the key, cert and cacert.
#
function icingaweb2::cert::files(
  String                         $name,
  Optional[Stdlib::Absolutepath] $default_dir,
  Optional[Stdlib::Absolutepath] $key_file    = undef,
  Optional[Stdlib::Absolutepath] $cert_file   = undef,
  Optional[Stdlib::Absolutepath] $cacert_file = undef,
  Optional[Icingaweb2::Secret]   $key         = undef,
  Optional[String]               $cert        = undef,
  Optional[String]               $cacert      = undef,
) >> Hash {
  # @param name
  #   The base name of certicate, key and ca file,
  #   if the corosponding file parameter is not set.
  #
  # @param default_dir
  #   The default directory to use for the stored files,
  #   if the corosponding file parameter is not set.
  #
  # @param key_file
  #   Location of the private key.
  #
  # @param cert_file
  #   Location of the certificate.
  #
  # @param cacert_file
  #   Location of the CA certificate.
  #
  # @param key
  #   The private key to store in specified key_file.
  #
  # @param cert
  #   The certificate to store in specified cert_file.
  #
  # @param cacert
  #   The CA certificate to store in specified cacert_file.
  #
  $result = {
    'key'         => icingaweb2::unwrap($key),
    'key_file'    => if $key {
      if $key_file {
        $key_file
      } else {
        "${default_dir}/${name}.key"
      }
    } else {
      $key_file
    },
    'cert'        => $cert,
    'cert_file'   => if $cert {
      if $cert_file {
        $cert_file
      } else {
        "${default_dir}/${name}.crt"
      }
    } else {
      $cert_file
    },
    'cacert'      => $cacert,
    'cacert_file' => if $cacert {
      if $cacert_file {
        $cacert_file
      } else {
        "${default_dir}/${name}_ca.crt"
      }
    } else {
      $cacert_file
    },
  }

  $result
}
