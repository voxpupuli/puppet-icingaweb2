function icingaweb2::unwrap(Variant[String, Sensitive[String]] $arg) >> String {
  if $arg =~ Sensitive {
    $arg.unwrap
  } else {
    $arg
  }
}
