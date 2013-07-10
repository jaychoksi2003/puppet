class nagios {
	package { ['httpd', 'nagios', 'nrpe', 'nagios-common', 'nagios-devel.x86_64', 'nagios-plugins', 'nagios-plugins-all', 'nagios-plugins-nrpe']:	
        ensure => installed,
        }

#        service { 'httpd':
#        ensure => running,
#        require => Package['httpd'],
#        enable => true,
#        }

	service { ['httpd', 'nagios']:
        ensure => running,
        require => Package['httpd', 'nagios'],
        enable => true,
        }


#        service { 'nagios':
#        ensure => running,
#        require => Package['nagios'],
#        enable => true,
#        }

	file { '/etc/httpd/conf.d/nagios.conf':
        source => 'puppet:///modules/nagios/nagios.conf',
        notify => Service['httpd'],
        }

	file { '/etc/nagios/nagios.cfg':
        source => 'puppet:///modules/nagios/nagios.cfg',
        notify => Service['nagios'],
        }

	file { "/usr/lib64/nagios/plugins/check_mem.pl":
        source => 'puppet:///modules/nagios/check_mem.pl',
        mode => 755,
        owner => "root",
        group  => "root",
        }



	file { [ '/etc/nagios/objects/servers' ]:
	ensure => directory,
	}

	file { "/etc/nagios/objects/servers/services.cfg":
        content => template('nagios/services.cfg.erb'),
        mode => 644,
        owner => "root",
        group  => "root",
        notify => Service['nagios'],
        }
		
		
	file { "/etc/nagios/objects/servers/group.cfg":
        content => template('nagios/group.cfg.erb'),
        mode => 644,
        owner => "root",
        group  => "root",
        notify => Service['nagios'],
        }

	#file { "/etc/nagios/objects/servers/others.cfg":
        #content => template('nagios/others.cfg.erb'),
        #mode => 644,
        #owner => "root",
        #group  => "root",
        #notify => Service['nagios'],
        #}


}
