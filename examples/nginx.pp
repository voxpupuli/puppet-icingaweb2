# Here is an example nginx resource for use with php-fpm and the
# voxpupuli-nginx module to get icingaweb2 running behind nginx.
#

$cn = 'icinga.example.com'
$tls_dir = '/etc/ssl'

nginx::resource::vhost { 'icingaweb':
  server_name          => [$cn],
  ssl                  => true,
  ssl_cert             => "${tls_dir}/${cn}/fullchain.pem",
  ssl_key              => "${tls_dir}/${cn}/privkey.pem",
  ssl_redirect         => true,
  index_files          => [],
  use_default_location => false,
  locations            => {
    'root'             => {
      location            => '/',
      vhost               => 'icingaweb',
      index_files         => [],
      location_custom_cfg => {
        'rewrite' => '^/(.*) https://$host/icingaweb2/$1 permanent'
      },
    },
    'icingaweb2_index' => {
      location       => '~ ^/icingaweb2/index\.php(.*)$',
      vhost          => 'icingaweb',
      ssl            => true,
      ssl_only       => true,
      index_files    => [],
      fastcgi        => '127.0.0.1:9000',
      fastcgi_index  => 'index.php',
      fastcgi_script => '/usr/share/icingaweb2/public/index.php',
      fastcgi_param  => {
        'ICINGAWEB_CONFIGDIR' => '/etc/icingaweb2',
        'REMOTE_USER'         => '$remote_user',
      },
    },
    'icingaweb2'       => {
      location       => '~ ^/icingaweb2(.+)?',
      location_alias => '/usr/share/icingaweb2/public',
      try_files      => ['$1', '$uri', '$uri/', '/icingaweb2/index.php$is_args$args'],
      index_files    => ['index.php'],
      vhost          => 'icingaweb',
      ssl            => true,
      ssl_only       => true,
    }
  }
}


