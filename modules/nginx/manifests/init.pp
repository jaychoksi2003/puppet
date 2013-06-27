class nginx {
	package { 'nginx':
	ensure => installed,
	}

	service { 'nginx':
	ensure => running,
	require => Package['nginx'],
#	enable => true,
	}

	file { '/var/www/cat-pictures/index.html':
	source => 'puppet:///modules/nginx/index.html',
	}
	file { '/etc/nginx/conf.d/cat-pictures.conf':
	source => 'puppet:///modules/nginx/cat-pictures.conf',
	notify => Service['nginx'],
	}
	
}
