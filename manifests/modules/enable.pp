#
#
#
#

define icingaweb2::modules::enable() {

  exec {
    "icingaweb2 enable module ${name}":
      user    => 'root',
      path    => [
        '/usr/bin',
        '/usr/sbin',
        '/bin',
        '/sbin'
      ],
      command => "ln -s /usr/share/icingaweb2/modules/${name} /etc/icingaweb2/enabledModules/${name}",
      onlyif  => "[ ! -L /etc/icingaweb2/enabledModules/${name} ]",
      require => Class['icingaweb2::install']
  }

}

# EOF
