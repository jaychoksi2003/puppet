class nagios {
	package { ['nagios', 'nrpe', 'nagios-common', 'nagios-devel.x86_64', 'nagios-plugins', 'nagios-plugins-all']:	
        ensure => installed,
        }

        service { 'nagios':
        ensure => running,
        require => Package['nagios'],
        enable => true,
        }

	file { '/etc/httpd/conf.d/nagios.conf':
        source => 'puppet:///modules/nagios/nagios.conf',
        notify => Service['httpd'],
        }

	file { '/etc/nagios/nagios.cfg':
        source => 'puppet:///modules/nagios/nagios.cfg',
        notify => Service['nagios'],
        }

	file { [ '/etc/nagios/objects/servers' ]:
	ensure => directory,
	}

	#file { "/etc/nagios/objects/servers/others.cfg":
        #content => template('nagios/others.cfg.erb'),
        #mode => 644,
        #owner => "root",
        #group  => "root",
        #notify => Service['nagios'],
        #}


}
