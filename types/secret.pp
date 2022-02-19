# A strict type for the secrets like passwords or keys
type Icingaweb2::Secret = Variant[String, Sensitive[String]]
