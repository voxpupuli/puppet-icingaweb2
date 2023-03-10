# @summary
#   Manage a dashboard.
#
# @param owner
#   Owner of the dashboard.
#
# @param dashboard
#   Title of the dashboard.
#
# @example Create a new Dashboard:
#   icingaweb2::config::dashboard { 'icingaadmin-NewDashboard':
#     owner     => 'icingaadmin',
#     dashboard => 'New Dashboard',
#   }
#
define icingaweb2::config::dashboard (
  String $owner,
  String $dashboard,
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

  icingaweb2::inisection { "dashboard-${owner}-${dashboard}":
    section_name => $dashboard,
    target       => "${conf_dir}/dashboards/${owner}/dashboard.ini",
    settings     => {
      'title' => $dashboard,
    },
  }
}
