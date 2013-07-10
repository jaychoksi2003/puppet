class nagiosclient {
	package { [ 'nrpe.x86_64', 'nagios-plugins', 'nagios-plugins-all', 'nagios-plugins-nrpe']:	
        ensure => installed,
        }

        service { 'nrpe':
        ensure => running,
        require => Package['nrpe.x86_64', 'nagios-plugins', 'nagios-plugins-all'],
        enable => true,
        }

	service { 'xinetd':
        ensure => running,
        enable => true,
        }

	file { "/etc/xinetd.d/nrpe":
	ensure => absent,
	notify => Service['xinetd'],
	}


	file { "/etc/nagios/nrpe.cfg":
        content => template('nagiosclient/nrpe.cfg.erb'),
	mode => 644,
        owner => "root",
        group  => "root",
        notify => Service['nrpe'],
        }
	
	file { "/usr/lib64/nagios/plugins/check_mem.pl":
        source => 'puppet:///modules/nagiosclient/check_mem.pl',
	mode => 755,
        owner => "root",
        group  => "root",
	require => Package['nrpe.x86_64', 'nagios-plugins', 'nagios-plugins-all'],
        }
	




}
