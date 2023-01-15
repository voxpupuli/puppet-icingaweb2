include icingaweb2

icingaweb2::config::role { 'mailadm':
  users       => 'bob, justsus',
  groups      => 'mailer',
  permissions => '*',
  filters     => {
    'monitoring/filter/object' => 'host_name=mail-*',
  },
}

icingaweb2::config::role { 'linuxer':
  users        => 'justus, peter',
  groups       => 'linuxer',
  parent       => 'mailer',
  permissions  => '*',
  filters      => {
    'monitoring/filter/object' => 'host_name=linux-*',
  },
  unrestricted => true,
}
