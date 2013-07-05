class nginx {
	package { 'nginx':
	ensure => installed,
	}

	service { 'nginx':
	ensure => running,
	require => Package['nginx'],
	enable => true,
	}
	
	file { '/etc/nginx/nginx.conf':
        source => 'puppet:///modules/nginx/nginx.conf',
        notify => Service['nginx'],
        }
	
}
