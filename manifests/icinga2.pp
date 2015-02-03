# == Class: icingaweb2::icinga2
#
class icingaweb2::icinga2 {

  if !defined(Icinga2::Server::Features::Enable['command']) {
    icinga2::server::features::enable { 'command':
    } ~> Service['icinga2'] # TODO: why?
  }

  # TODO:

}
# vi: ts=2 sw=2 expandtab :
