# @summary
#   Roles define a set of permissions that may be applied to users or groups.
#
# @param [String] role_name
#   Name of the role.
#
# @param [Optional[String]] users
#   Comma separated list of users this role applies to.
#
# @param [Optional[String]] groups
#   Comma separated list of groups this role applies to.
#
# @param [Optional[String]] permissions
#   Comma separated lsit of permissions. Each module may add it's own permissions. Examples are
#   - Allow everything: '*'
#   - Allow config access: 'config/*'
#   - Allow access do module monitoring: 'module/monitoring'
#   - Allow scheduling checks: 'monitoring/command/schedule-checks'
#   - Grant admin permissions: 'admin'
#
# @param [Hash] filters
#   Hash of filters. Modules may add new filter keys, some sample keys are:
#   - application/share/users
#   - application/share/groups
#   - monitoring/filter/objects
#   - monitoring/blacklist/properties
#   A string value is expected for each used key. For example:
#   - monitoring/filter/objects = "host_name!=*win*"
#
# @example Create role that allows only hosts beginning with `linux-*`:
#   icingaweb2::config::role{ 'linux-user':
#     groups      => 'linuxer',
#     permissions => '*',
#     filters     => {
#       'monitoring/filter/objects' => 'host_name=linux-*'
#     }
#   }
#
# @note Availble permissions in module monitoring:
#   | Description | Value |
#   |-------------|-------|
#   | Allow everything | `*` |
#   | Allow to share navigation items | `application/share/navigation` |
#   | Allow to adjust in the preferences whether to show stacktraces | `application/stacktraces` |
#   | Allow to view the application log | `application/log` |
#   | Grant admin permissions, e.g. manage announcements | `admin` |
#   | Allow config access | `config/*` |
#   | Allow access to module doc | `module/doc` |
#   | Allow access to module monitoring | `module/monitoring` |
#   | Allow all commands | `monitoring/command/*` |
#   | Allow scheduling host and service checks | `monitoring/command/schedule-check` |
#   | Allow acknowledging host and service problems | `monitoring/command/acknowledge-problem` |
#   | Allow removing problem acknowledgements | `monitoring/command/remove-acknowledgement` |
#   | Allow adding and deleting host and service comments | `monitoring/command/comment/*` |
#   | Allow commenting on hosts and services | `monitoring/command/comment/add` |
#   | Allow deleting host and service comments | `monitoring/command/comment/delete` |
#   | Allow scheduling and deleting host and service downtimes | `monitoring/command/downtime/*` |
#   | Allow scheduling host and service downtimes | `monitoring/command/downtime/schedule` |
#   | Allow deleting host and service downtimes | `monitoring/command/downtime/delete` |
#   | Allow processing host and service check results | `monitoring/command/process-check-result` |
#   | Allow processing commands for toggling features on an instance-wide basis | `monitoring/command/feature/instance` |
#   | Allow processing commands for toggling features on host and service objects | `monitoring/command/feature/object/*`) |
#   | Allow processing commands for toggling active checks on host and service objects | `monitoring/command/feature/object/active-checks` |
#   | Allow processing commands for toggling passive checks on host and service objects | `monitoring/command/feature/object/passive-checks` |
#   | Allow processing commands for toggling notifications on host and service objects | `monitoring/command/feature/object/notifications` |
#   | Allow processing commands for toggling event handlers on host and service objects | `monitoring/command/feature/object/event-handler` |
#   | Allow processing commands for toggling flap detection on host and service objects | `monitoring/command/feature/object/flap-detection` |
#   | Allow sending custom notifications for hosts and services | `monitoring/command/send-custom-notification` |
#   | Allow access to module setup | `module/setup` |
#   | Allow access to module test | `module/test` |
#   | Allow access to module translation | `module/translation` |
#
# @note With the monitoring module, possible filters are:
#   * `application/share/users`
#   * `application/share/groups`
#   * `monitoring/filter/objects`
#   * `monitoring/blacklist/properties`
#
# @example Create role that allows a user to see only hosts beginning with `linux-*`:
#   icingaweb2::config::role{'linux-user':
#     users       => 'bob, pete',
#     permissions => '*',
#     filters     => {
#       'monitoring/filter/objects' => 'host_name=linux-*',
#     }
#   }
#
define icingaweb2::config::role(
  String           $role_name   = $title,
  Optional[String] $users       = undef,
  Optional[String] $groups      = undef,
  Optional[String] $permissions = undef,
  Hash             $filters     = {},
) {

  $conf_dir = $::icingaweb2::globals::conf_dir

  $settings = {
    'users'       => $users,
    'groups'      => $groups,
    'permissions' => $permissions,
  }

  icingaweb2::inisection{ "role-${role_name}":
    section_name => $role_name,
    target       => "${conf_dir}/roles.ini",
    settings     => delete_undef_values(merge($settings,$filters))
  }
}
