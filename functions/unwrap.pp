function icingaweb2::unwrap(Optional[Variant[String, Sensitive[String]]] $arg = undef) {
  if $arg =~ Sensitive {
    $arg.unwrap
  } else {
    $arg
  }
}
