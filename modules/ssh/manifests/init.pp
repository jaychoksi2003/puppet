class ssh {

	service { 'sshd':
	ensure => running,
	enable => true,
	}

	file { '/etc/ssh/sshd_config':
	source => 'puppet:///modules/ssh/sshd_config',
	notify => Service['sshd'],
	}
	
}
