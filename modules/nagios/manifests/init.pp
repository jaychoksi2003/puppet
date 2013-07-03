class nagios {
	package { ['nagios', 'nrpe', 'nagios-common', 'nagios-devel.x86_64', 'nagios-plugins', 'nagios-plugins-all']:	
        ensure => installed,
        }

        service { 'nagios':
        ensure => running,
        require => Package['nagios'],
        enable => true,
        }



}
