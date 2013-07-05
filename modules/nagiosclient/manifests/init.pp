class nagiosclient {
	package { [ 'nrpe', 'nagios-plugins', 'nagios-plugins-all']:	
        ensure => installed,
        }

        service { 'nrpe':
        ensure => running,
        require => Package['nagiosclient'],
        enable => true,
        }

}
