# A strict type for the default admin role
type Icingaweb2::AdminRole = Struct[{
  name   => String,
  users  => Optional[Array[String]],
  groups => Optional[Array[String]],
}]
