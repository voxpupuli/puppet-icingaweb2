# @summary
#   Navigate defines a menu entry, host- or service action.
#
# @param item_name
#   Name of the menu entry, host- or service action.
#
# @param owner
#   Owner of the navigation item.
#
# @param type
#   Type of the navigation item.
#
# @param shared
#   Creates a shared navigation item.
#
# @param users
#   List of users who have access to the element. Only valid if shared.
#
# @param groups
#   List of user groups that have access to the element. Only valid if shared.
#
# @param parent
#   The name of the a parent item. Only valid for menu entries.
#   Important: `shared` has to set if the parent entry is also `shared`.
#
# @param target
#   The target to view the content.
#
# @param url
#   Url to the content of the navigation item.
#
# @param icon
#   Location of an icon for the navigation item.
#
# @param filter
#   Filter to restrict the result of the content. Only valid for actions.
#
define icingaweb2::config::navigation (
  String                  $owner,
  String                  $url,
  String                  $item_name    = $title,
  Enum[
    'menu-item',
    'host-action',
    'service-action'
  ]                       $type         = 'menu-item',
  Boolean                 $shared       = false,
  Optional[Array[String]] $users        = undef,
  Optional[Array[String]] $groups       = undef,
  Enum['_blank', '_main'] $target       = '_main',
  Optional[String]        $parent       = undef,
  Optional[String]        $icon         = undef,
  Optional[String]        $filter       = undef,
) {
  require icingaweb2::globals

  $conf_dir   = $icingaweb2::globals::conf_dir
  $conf_user  = $icingaweb2::conf_user
  $conf_group = $icingaweb2::conf_group

  $ini_file = $type ? {
    'host-action'    => 'host-actions.ini',
    'service-action' => 'service-actions.ini',
    default          => 'menu.ini',
  }

  $settings = {
    'type'   => $type,
    'target' => $target,
    'url'    => $url,
    'users'  => if $users and $shared and (!$parent or $type != 'menu-item') { join($users, ', ') } else { undef },
    'groups' => if $groups and $shared and (!$parent or $type != 'menu-item') { join($groups, ', ') } else { undef },
    'parent' => if $type == 'menu-item' { $parent } else { undef },
    'icon'   => $icon,
    'filter' => unless $type == 'menu-item' { $filter } else { undef },
    'owner'  => if $shared { $owner } else { undef },
  }

  if $shared {
    $file_target = "${conf_dir}/navigation/${ini_file}"
  } else {
    $file_target = "${conf_dir}/preferences/${owner}/${ini_file}"
    ensure_resource('file', "${conf_dir}/preferences/${owner}", {
      ensure => directory,
      owner  => $conf_user,
      group  => $conf_group,
      mode   => '2770',
    })
  }

  icingaweb2::inisection { "navigation-${item_name}":
    section_name => $item_name,
    target       => $file_target,
    settings     => delete_undef_values($settings),
  }
}
