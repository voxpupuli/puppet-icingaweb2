# == Class: icingaweb2::module::vspheredb
#
# Installs the vSphereDB module, which is used to monitor host systems, virtual machines, data stores and much more.
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
# [*db_type*]
#   Type of your database. Currently, only 'mysql' is available.
#
# [*db_host*]
#   Hostname of the database.
#
# [*db_port*]
#   Port of the database. Defaults to `3306`
#
# [*db_name*]
#   Name of the database.
#
# [*db_username*]
#   Username for DB connection.
#
# [*db_password*]
#   Password for DB connection.
#
# [*db_charset*]
#   The charachter encoding used for the DB. Defaults to 'utf8mb4' as per the documentation
#
# [*configure_daemon*]
#   Configure the systemd background daemon
#
class icingaweb2::module::vspheredb(
  Enum['absent', 'present'] $ensure           = 'present',
  String                    $git_repository   = 'https://github.com/Icinga/icingaweb2-module-vspheredb.git',
  Optional[String]          $git_revision     = undef,
  Enum['mysql']             $db_type          = 'mysql',
  Optional[String]          $db_host          = undef,
  Integer[1,65535]          $db_port          = 3306,
  Optional[String]          $db_name          = undef,
  Optional[String]          $db_username      = undef,
  Optional[String]          $db_password      = undef,
  Optional[String]          $db_charset       = 'utf8mb4',
  Boolean                   $configure_daemon = false,
){

  $_module_conf_dir = "${::icingaweb2::params::conf_dir}/modules/vspheredb"

  ::icingaweb2::config::resource { 'icingaweb2-module-vspheredb':
    type        => 'db',
    db_type     => $db_type,
    host        => $db_host,
    port        => $db_port,
    db_name     => $db_name,
    db_username => $db_username,
    db_password => $db_password,
    db_charset  => $db_charset,
  }

  ::icingaweb2::module { 'vspheredb':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    settings       => {
      'module-vspheredb-db' => {
        'section_name' => 'db',
        'target'       => "${_module_conf_dir}/config.ini",
        'settings'     => {
          'resource' => 'icingaweb2-module-vspheredb',
        },
      },
    },
  }

  if $configure_daemon {
    ::systemd::unit_file { 'icinga-vspheredb.service':
      ensure => $ensure,
      enable => true,
      active => true,
      source => "${::icingaweb2::params::module_path}/vspheredb/contrib/systemd/icinga-vspheredb.service",
    }
  }

}
