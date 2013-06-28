class ssh {
	package { 'openssh-server':
        ensure => latest
	} 
	service { 'sshd':
	ensure => running,
	enable => true,
	require   => Package['openssh-server'],
	}

	file { '/etc/ssh/sshd_config':
	source => 'puppet:///modules/ssh/sshd_config',
	owner => root,
	group   => root,
        mode    => 644,
	notify => Service['sshd'],
	}
	
}
