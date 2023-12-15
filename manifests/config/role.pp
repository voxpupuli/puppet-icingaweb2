# @summary
#   Roles define a set of permissions that may be applied to users or groups.
#
# @param role_name
#   Name of the role.
#
# @param users
#   Comma separated list of users this role applies to.
#
# @param groups
#   Comma separated list of groups this role applies to.
#
# @param parent
#   The name of the role from which to inherit privileges.
#
# @param permissions
#   Comma separated lsit of permissions. Each module may add it's own permissions. Examples are
#   - Allow everything: '*'
#   - Allow config access: 'config/*'
#   - Allow access do module icingadb: 'module/icingadb'
#   - Allow scheduling checks: 'icingadb/command/schedule-checks'
#   - Grant admin permissions: 'admin'
#
# @param refusals
#   Refusals are used to deny access. So they’re the exact opposite of permissions.
#
# @param unrestricted
#   If set to `true`, owners of this role are not restricted in any way.
#
# @param filters
#   Hash of filters. Modules may add new filter keys, some sample keys are:
#   - application/share/users
#   - application/share/groups
#   - icingadb/filter/objects
#   A string value is expected for each used key. For example:
#   - icingadb/filter/objects = "host_name!=*win*"
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
define icingaweb2::config::role (
  String            $role_name    = $title,
  Optional[String]  $users        = undef,
  Optional[String]  $groups       = undef,
  Optional[String]  $parent       = undef,
  Optional[String]  $permissions  = undef,
  Optional[String]  $refusals     = undef,
  Optional[Boolean] $unrestricted = undef,
  Hash              $filters      = {},
) {
  $conf_dir = $icingaweb2::globals::conf_dir
  $replace  = $icingaweb2::globals::role_replace

  $settings = {
    'users'        => $users,
    'groups'       => $groups,
    'parent'       => $parent,
    'permissions'  => $permissions,
    'refusals'     => $refusals,
    'unrestricted' => $unrestricted,
  }

  icingaweb2::inisection { "role-${role_name}":
    section_name => $role_name,
    target       => "${conf_dir}/roles.ini",
    settings     => delete_undef_values($settings + $filters),
    replace      => $replace,
  }
}
