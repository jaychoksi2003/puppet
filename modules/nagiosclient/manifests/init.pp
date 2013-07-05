class nagiosclient {
	package { [ 'nrpe.x86_64', 'nagios-plugins', 'nagios-plugins-all']:	
        ensure => installed,
        }

        #service { 'nrpe':
        #ensure => running,
        #require => Package['nagiosclient'],
        #enable => true,
        #}

}
