# Manage an Nginx virtual host
define nginx::website( $site_domain ) {
	include nginx
	$site_name = $name

	file { "/etc/nginx/conf.d/${site_name}.conf":
	content => template('nginx/vhost.conf.erb'),
	notify => Service['nginx'],
	}

	file { "/var/www/${site_name}":
	ensure => "directory",
	mode => 755,
	owner => "nginx",
	group  => "nginx",
	}

	file { "/var/www/${site_name}/index.html":
        source => 'puppet:///modules/nginx/index.html',
	mode => 755,
        owner => nginx,
	group  => "nginx",
        }

}

