# == Class: icingaweb2::module::elasticsearch
#
# The Elasticsearch module displays events from data stored in Elasticsearch.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
# [*git_repository*]
#   Set a git repository URL. Defaults to github.
#
# [*git_revision*]
#   Set either a branch or a tag name, eg. `master` or `v1.3.2`.
#
# [*install_method*]
#   Install methods are `git`, `package` and `none` is supported as installation method. Defaults to `git`
#
# [*package_name*]
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#   Defaults to `icingaweb2-module-elasticsearch`
#
# [*instances*]
#   A hash that configures one or more Elasticsearch instances that this module connects to. The defined type
#   `icingaweb2::module::elasticsearch::instance` is used to create the instance configuration.
#
# [*eventtypes*]
#   A hash oft ypes of events that should be displayed. Event types are always connected to instances. The defined type
#   `icingaweb2::module::elasticsearch::eventtype` is used to create the event types.
#
class icingaweb2::module::elasticsearch(
  Enum['absent', 'present']      $ensure         = 'present',
  String                         $git_repository = 'https://github.com/Icinga/icingaweb2-module-elasticsearch.git',
  Optional[String]               $git_revision   = undef,
  Enum['git', 'none', 'package'] $install_method = 'git',
  Optional[String]               $package_name   = 'icingaweb2-module-elasticsearch',
  Optional[Hash]                 $instances      = undef,
  Optional[Hash]                 $eventtypes     = undef,
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
    install_method => $install_method,
    package_name   => $package_name,
  }
}
