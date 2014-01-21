# Manage an Http virtual host
define httpd::website( $site_domain ) {
	include httpd
	$site_name = $name

	file { "/etc/httpd/conf.d/${site_name}.conf":
	content => template('httpd/vhost.conf.erb'),
	notify => Service['httpd'],
	}

	file { "/var/www/html/${site_name}":
	ensure => "directory",
	mode => 755,
	owner => "apache",
	group  => "apache",
	}

	file { "/var/www/html/${site_name}/index.html":
        source => 'puppet:///modules/httpd/index.html',
	mode => 755,
        owner => "apache",
	group  => "apache",
        }

}

