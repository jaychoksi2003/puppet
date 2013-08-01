class vms:install {
	package {  'rng-tools':
	ensure => installed,
	}


	service { 'rngd':
        ensure => running,
        require => Package['rng-tools'],
        enable => true,
        }
}	
