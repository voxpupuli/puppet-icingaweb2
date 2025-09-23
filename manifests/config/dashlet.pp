# @summary
#   Manage a dashlet.
#
# @param owner
#   Owner of the dashlet.
#
# @param dashboard
#   Dashboard to which the dashlet belongs.
#
# @param dashlet
#   Name of the dashlet.
#
# @param url
#   URL of the dashlet.
#
# @example Create a new Dashboard with a Dashlet:
#   icingaweb2::config::dashboard { 'icingaadmin-NewDashboard':
#     owner     => 'icingaadmin',
#     dashboard => 'New Dashboard',
#   }
#
#   icingaweb2::config::dashlet { 'icingaadmin-NewDashboard':
#     owner     => 'icingaadmin',
#     dashboard => 'New Dashboard',
#     dashlet   => 'New Dashlet',
#     url       => 'monitoring/list/hosts',
#   }
#
# @example Add new Dashlet to an existing default dashboard:
#   icingaweb2::config::dashlet { 'icingaadmin-Overdue-NewDashlet':
#     owner     => 'icingaadmin',
#     dashboard => 'Overdue',
#     dashlet   => 'New Dashlet',
#     url       => 'monitoring/list/hosts',
#   }
#
define icingaweb2::config::dashlet (
  String $owner,
  String $dashboard,
  String $dashlet,
  String $url,
) {
  require icingaweb2::globals

  $conf_dir   = $icingaweb2::globals::conf_dir
  $conf_user  = $icingaweb2::conf_user
  $conf_group = $icingaweb2::conf_group

  ensure_resource('file', "${conf_dir}/dashboards/${owner}", {
    ensure => directory,
    owner  => $conf_user,
    group  => $conf_group,
    mode   => '2770',
  })

  icingaweb2::inisection { "dashboard-${owner}-${dashboard}-${dashlet}":
    section_name => "${dashboard}.${dashlet}",
    target       => "${conf_dir}/dashboards/${owner}/dashboard.ini",
    settings     => {
      'title' => $dashlet,
      'url'   => $url,
    },
  }
}
