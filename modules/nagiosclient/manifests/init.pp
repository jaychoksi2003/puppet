class nagiosclient {
	package { [ 'nrpe.x86_64', 'nagios-plugins', 'nagios-plugins-all']:	
        ensure => installed,
        }

        service { 'nrpe':
        ensure => running,
        require => Package['nrpe.x86_64', 'nagios-plugins', 'nagios-plugins-all'],
        enable => true,
        }

	file { "/etc/nagios/nrpe.conf":
        content => template('nagiosclient/nrpe.conf.erb'),
	mode => 644,
        owner => "root",
        group  => "root",
        notify => Service['nrpe'],
        }
$nagios_server = pserver,
}
