# @summary
#   Manages an Elasticsearch event types
#
# @param eventtype_name
#   Name of the event type.
#
# @param instance
#   Elasticsearch instance to connect to.
#
# @param index
#   Elasticsearch index pattern, e.g. `filebeat-*`.
#
# @param filter
#   Elasticsearch filter in the Icinga Web 2 URL filter format. Host macros are evaluated if you encapsulate them in
#   curly braces, e.g. `host={host.name}&location={_host_location}`.
#
# @param fields
#   Comma-separated list of field names to display. One or more wildcard asterisk (`*`) patterns are also accepted.
#   Note that the `@timestamp` field is always respected.
#
# @api private
#
define icingaweb2::module::elasticsearch::eventtype (
  String[1]             $eventtype_name = $title,
  Optional[String[1]]   $instance       = undef,
  Optional[String[1]]   $index          = undef,
  Optional[String[1]]   $filter         = undef,
  Optional[String[1]]   $fields         = undef,
) {
  assert_private("You're not supposed to use this defined type manually.")

  $conf_dir        = $icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/elasticsearch"

  $eventtype_settings = {
    'instance' => $instance,
    'index'    => $index,
    'filter'   => $filter,
    'fields'   => $fields,
  }

  icingaweb2::inisection { "elasticsearch-eventtype-${eventtype_name}":
    section_name => $eventtype_name,
    target       => "${module_conf_dir}/eventtypes.ini",
    settings     => delete_undef_values($eventtype_settings),
  }
}
