# @summary
#   Import or update the database schema. Also start the initial kickstart run if required.
#
# @api private
#
class icingaweb2::module::director::kickstart {
  assert_private()

  $import_schema  = $icingaweb2::module::director::import_schema
  $kickstart      = $icingaweb2::module::director::kickstart
  $icingacli_bin  = $icingaweb2::globals::icingacli_bin

  if $import_schema {
    exec { 'director-migration':
      command => "${icingacli_bin} director migration run",
      onlyif  => "${icingacli_bin} director migration pending",
    }

    if $kickstart {
      exec { 'director-kickstart':
        command => "${icingacli_bin} director kickstart run",
        onlyif  => "${icingacli_bin} director kickstart required",
        require => Exec['director-migration'],
      }
    }
  }
}
