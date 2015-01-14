class icingaweb2::depends {

    include ::apache
    include ::apache::mod::php
    include ::apache::mod::rewrite

    # temporary fix for the apache module
    # TODO: check
    Service <| title == 'httpd' |> {
        hasrestart => true,
    }

    package { 'zendframework':
        ensure  => installed,
        require => Class['apache::mod::php']
    }

    package { 'php5-mysql':
        ensure  => installed,
        require => Class['apache::mod::php']
    }

    package { 'php5-ldap':
        ensure  => installed,
        require => Class['apache::mod::php']
    }
}
