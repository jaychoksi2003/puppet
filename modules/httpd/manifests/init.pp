class httpd {
	package { 'httpd':
	ensure => installed,
	}

	service { 'httpd':
	ensure => running,
	require => Package['httpd'],
	enable => true,
	}
	
	file { '/etc/httpd/conf/httpd.conf':
	source => 'puppet:///modules/httpd/httpd.conf',
	notify => Service['httpd'],
	}
	
}
