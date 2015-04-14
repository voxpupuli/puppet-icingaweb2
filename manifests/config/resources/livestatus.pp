# Define for setting IcingaWeb2 LiveStatus
#
#
#

class icingaweb2::config::resources::livestatus (
  $socket,
) {

  concat::fragment {
    "icingaweb2_resources_livestatus":
      target  => "icingaweb2_resources",
      content => template( 'icingaweb2/resources/livestatus.erb' ),
      order   => 40
  }

}

# EOF
