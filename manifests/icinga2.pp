class icingaweb2::icinga2 {

  if !defined(Icinga2::Server::Features::Enable['command']) {
    icinga2::server::features::enable { 'command':
    }
  }

  # TODO:

}
# vi: ts=2 sw=2 expandtab :
