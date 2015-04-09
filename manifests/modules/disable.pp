#
#
#
#

define icingaweb2::modules::disable() {

  exec {
    "icingaweb2 disable module ${name}":
      user    => 'root',
      path    => [
        '/usr/bin',
        '/usr/sbin',
        '/bin',
        '/sbin'
      ],
      command => "rm -f /etc/icingaweb2/enabledModules/${name}",
      unless  => "[ ! -L /etc/icingaweb2/enabledModules/${name} ]",
      require => Class['icingaweb2::install']
  }

}

# EOF


