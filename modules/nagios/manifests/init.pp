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
class httpd {
        
	service { 'httpd':
        ensure => running,
        require => Package['httpd'],
        enable => true,
        }

	file { '/etc/httpd/conf.d/nagios.conf':
        source => 'puppet:///modules/nagios/nagios.conf',
        notify => Service['httpd'],
        }


}
