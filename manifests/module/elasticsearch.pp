# @summary
#   The Elasticsearch module displays events from data stored in Elasticsearch.
#
# @param [Enum['absent', 'present']] ensure
#   Enable or disable module.
#
# @param [String] git_repository
#   Set a git repository URL.
#
# @param [Optional[String]] git_revision
#   Set either a branch or a tag name, eg. `master` or `v1.3.2`.
#
# @param [Optional[Hash]] instances
#   A hash that configures one or more Elasticsearch instances that this module connects to. The defined type
#   `icingaweb2::module::elasticsearch::instance` is used to create the instance configuration.
#
# @param [Optional[Hash]] eventtypes
#   A hash oft ypes of events that should be displayed. Event types are always connected to instances. The defined type
#   `icingaweb2::module::elasticsearch::eventtype` is used to create the event types.
#
# @example
#   class { 'icingaweb2::module::elasticsearch':
#     git_revision => 'v0.9.0',
#     instances    => {
#       'elastic'  => {
#         uri      => 'http://localhost:9200',
#         user     => 'foo',
#         password => 'bar',
#       }
#     },
#     eventtypes   => {
#       'filebeat' => {
#         instance => 'elastic',
#         index    => 'filebeat-*',
#         filter   => 'beat.hostname={host.name}',
#         fields   => 'input_type, source, message',
#       }
#     }
#   }
#
class icingaweb2::module::elasticsearch(
  String                      $git_repository,
  Enum['absent', 'present']   $ensure         = 'present',
  Optional[String]            $git_revision   = undef,
  Optional[Hash]              $instances      = undef,
  Optional[Hash]              $eventtypes     = undef,
){

  if $instances {
    $instances.each |$name, $setting| {
      icingaweb2::module::elasticsearch::instance{ $name:
        uri                => $setting['uri'],
        user               => $setting['user'],
        password           => $setting['password'],
        ca                 => $setting['ca'],
        client_certificate => $setting['client_certificate'],
        client_private_key => $setting['client_private_key'],
      }
    }
  }

  if $eventtypes {
    $eventtypes.each |$name, $setting| {
      icingaweb2::module::elasticsearch::eventtype { $name:
        instance => $setting['instance'],
        index    => $setting['index'],
        filter   => $setting['filter'],
        fields   => $setting['fields'],
      }
    }
  }

  icingaweb2::module { 'elasticsearch':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }
}
