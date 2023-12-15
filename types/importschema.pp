# A type for setting import database schemata
type Icingaweb2::ImportSchema = Variant[Boolean, Enum['mariadb', 'mysql']]
