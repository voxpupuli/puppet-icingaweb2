# == Class: icingaweb2
#
# Full description of class icingaweb2 here.
#
class icingaweb2 {

    include icingaweb2::depends

    Exec {
        path        => [ '.', $::path],
        cwd         => '/opt/icingaweb2',
        environment => [
            'http_proxy=http://172.16.0.15:80',
            'https_proxy=http://172.16.0.15:80',
        ],
    }

    $db_icingaweb2 = trocla('icinga/master/db_icingaweb2', 'plain')

    file { '/opt/icingaweb2':
        ensure => directory,
        owner  => 'www-data',
        group  => 'www-data',
        mode   => '0750',
    } ->

    exec { 'icingaweb2-git-clone':
        command => 'git clone https://git.icinga.org/icingaweb2.git .',
        user    => 'www-data',
        cwd     => '/opt/icingaweb2',
        creates => '/opt/icingaweb2/.git',
    } ->

    exec { 'icingaweb2-configure':
        command => "/opt/icingaweb2/configure --prefix=/opt/icingaweb2 --with-internal-authentication --with-internal-db-name=icingaweb2 --with-internal-db-user=icingaweb2 --with-internal-db-password=\"'$db_icingaweb2'\"",
        user    => 'www-data',
        cwd     => '/opt/icingaweb2',
        creates => '/opt/icingaweb2/config.status',
    } ->

    file { 'icingaweb2-apache2':
        ensure => file,
        path   => "${::apache::confd_dir}/icingaweb2.conf",
        content => template('icingaweb2/icingaweb2.conf'),
    } ~> Class['apache::service']

    mysql::db { 'icingaweb2':
        user     => 'icingaweb2',
        password => $db_icingaweb2,
        sql      => '/opt/icingaweb2/etc/schema/accounts.mysql.sql',
        require  => Exec['icingaweb2-git-clone'],
    }

    icinga2::server::features::enable { 'command':
    }
    icinga2::server::features::enable { 'compatlog':
    }
    icinga2::server::features::enable { 'statusdata':
    }

}
