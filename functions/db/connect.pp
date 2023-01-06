# @summary
#   This function returns a string to connect databases
#   with or without TLS information.
#
# @return
#   Connection string to connect database.
#
function icingaweb2::db::connect(
  Struct[{
      type => Enum['pgsql','mysql','mariadb'],
      host => Stdlib::Host,
      port => Stdlib::Port,
      name => String,
      user => String,
      pass => Optional[Icingaweb2::Secret],
  }]                   $db,
  Hash[String, Any]    $tls,
  Optional[Boolean]    $use_tls = undef,
) >> String {
  # @param db
  #    Data hash with database information.
  #
  # @param tls
  #   Data hash with TLS connection information.
  #
  # @param use_tls
  #   Wether or not to use TLS encryption.
  #
  if $use_tls {
    case $db['type'] {
      'pgsql': {
        $tls_options = regsubst(join(any2array(delete_undef_values({
                  'sslmode='     => if $tls['noverify'] { 'require' } else { 'verify-full' },
                  'sslcert='     => $tls['cert_file'],
                  'sslkey='      => $tls['key_file'],
                  'sslrootcert=' => $tls['cacert_file'],
        })), ' '), '= ', '=', 'G')
      }
      'mariadb': {
        $tls_options = join(any2array(delete_undef_values({
                '--ssl'        => '',
                '--ssl-ca'     => $tls['cacert_file'],
                '--ssl-cert'   => $tls['cert_file'],
                '--ssl-key'    => $tls['key_file'],
                '--ssl-capath' => $tls['capath'],
                '--ssl-cipher' => $tls['cipher'],
        })), ' ')
      }
      'mysql': {
        $tls_options = join(any2array(delete_undef_values({
                '--ssl-mode'   => 'required',
                '--ssl-ca'     => $tls['cacert_file'],
                '--ssl-cert'   => $tls['cert_file'],
                '--ssl-key'    => $tls['key_file'],
                '--ssl-capath' => $tls['capath'],
                '--ssl-cipher' => $tls['cipher'],
        })), ' ')
      }
      default: {
        fail('The database type you provided is not supported.')
      }
    }
  } else {
    $tls_options = ''
  }

  if $db['type'] == 'pgsql' {
    $options = regsubst(join(any2array(delete_undef_values({
              'host='        => $db['host'],
              'user='        => $db['user'],
              'port='        => $db['port'],
              'dbname='      => $db['name'],
    })), ' '), '= ', '=', 'G')
  } else {
    $_password = icingaweb2::unwrap($db['pass'])
    $options = join(any2array(delete_undef_values({
            '-h'               => $db['host'] ? {
              /localhost/  => undef,
              default      => $db['host'],
            },
            '-P'               => $db['port'],
            '-u'               => $db['user'],
            "-p'${_password}'" => '',
            '-D'               => $db['name'],
    })), ' ')
  }

  "${options} ${tls_options}"
}
