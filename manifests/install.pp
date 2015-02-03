# == Class: icingaweb2::install
#
class icingaweb2::install {

  # TODO: db type?
  if !defined(Package[php-mysql]) {
    package { 'php-mysql':
      ensure  => installed,
    } ~> Service['httpd']
  }
  if !defined(Package[php-gd]) {
    package { 'php-gd':
      ensure  => installed,
    } ~> Service['httpd']
  }
  if !defined(Package[php-intl]) {
    package { 'php-intl':
      ensure  => installed,
    } ~> Service['httpd']
  }

  if $::osfamily == 'Redhat' {
    package { 'php-ZendFramework-Db-Adapter-Pdo-Mysql':
      ensure => installed,
    }
    package { 'php-ZendFramework-Db-Adapter-Pdo-Pgsql':
      ensure => installed,
    }
  }

  package { 'icingaweb2':
    ensure  => latest,
  }

  package { 'icingacli':
    ensure  => latest,
  }

  # TODO: other packages on latest?

}
# vi: ts=2 sw=2 expandtab :
