# A strict type for HTTP basic authentication credentials.
type Icingaweb2::BasicAuth = Struct[{
  'username' => String[1],
  'password' => Icinga::Secret,
}]
