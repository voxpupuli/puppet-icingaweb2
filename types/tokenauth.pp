# A strict type for token authentication credentials.
type Icingaweb2::TokenAuth = Struct[{
  'type'  => String[1],
  'value' => Icinga::Secret,
}]
