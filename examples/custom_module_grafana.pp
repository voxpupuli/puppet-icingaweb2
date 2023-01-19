class { 'icinga::repos':
  manage_extras => true,
}

include icingaweb2

$conf_dir        = $icingaweb2::globals::conf_dir
$module_conf_dir = "${conf_dir}/modules/grafana"

$settings = {
  'grafana' => {
    'target'   => "${module_conf_dir}/config.ini",
    'settings' => {
      'username'              => 'your grafana username',
      'host'                  => 'hostname:3000',
      'protocol'              => 'https',
      'password'              => '123456',
      'height'                => '280',
      'width'                 => '640',
      'timerange'             => '3h',
      'enableLink'            => 'yes',
      'defaultorgid'          => '1',
      'defaultdashboard'      => 'icinga2-default',
      'shadows'               => '1',
      'datasource'            => 'influxdb',
      'defaultdashboardstore' => 'db',
      'accessmode'            => 'proxy',
      'timeout'               => '5',
      'directrefresh'         => 'no',
      'usepublic'             => 'no',
      'publichost'            => 'otherhost:3000',
      'publicprotocol'        => 'http',
      'custvardisable'        => 'idontwanttoseeagraph',
    },
  },
}

icingaweb2::module { 'grafana':
  install_method => 'package',
  package_name   => 'icingaweb2-module-grafana',
  settings       => $settings,
}
