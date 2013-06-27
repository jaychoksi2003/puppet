class httpd {
	package { 'httpd':
	ensure => installed,
	}

	service { 'httpd':
	ensure => running,
	require => Package['httpd'],
	enable => true,
	}

	file { '/var/www/html/cat-pictures/index.html':
	source => 'puppet:///modules/httpd/index.html',
	}

	file { '/etc/httpd/conf.d/cat-pictures.conf':
	source => 'puppet:///modules/httpd/cat-pictures.conf',
	notify => Service['httpd'],
	}
	
	file { '/etc/httpd/conf/httpd.conf':
	source => 'puppet:///modules/httpd/httpd.conf',
	notify => Service['httpd'],
	}
	
}
