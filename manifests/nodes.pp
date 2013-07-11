node 'pserver' {
	include nginx
	include httpd
	include git
	include labdns
	include epel
	include nagios
########################## nagiso node declaration ###########
	nagios::addclient { 'pclient':
        site_domain => '10.122.90.52',
        }

	nagios::addclient { 'RequestTracker':
        site_domain => 'rt',
        }
################################## Custom Modification ####################
	user { 'jboss':
	ensure => present,
	comment => 'Jboss Users manage by puppet',
	home => '/opt/jboss',
	managehome => true,
	}
	
	ssh_authorized_key { 'jboss_ssh':
	user => 'jboss',
	type => 'rsa',
	key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAxZdO1cSsx0seJzT7DAwsy/T2+dgcxT78ZwJ0g+ArLZK5o8hHvlxR8fLpmsXNkHQ2jub9biv5ga+4BqGIpxA33hCcrGsVXo8+lX9z53A0kWAwLOw/VUU6OmClbq9acQ/HssC9mQ2kgD/lCu2ndSPR/XpOepFVd+Z6i654XtB4QBhjXkA8O0gvctJ2AFttwsaEINQokgcN2Cgtuwry8IGnCPNExlHiYUuRa+0x6aH+o2Mvko34Di1jaEJS0+9qxPiRmMDLamyKWehqOiIDULv1hF3zluYAnBc4pC5fuT13//CFL74UAi6KfooYvZIuk3qV7TXEjC/gsXF3t/pAyH7r3Q=='
	}
	
	ssh_authorized_key { 'root_ssh':
	user => 'root',
	type => 'rsa',
	key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAxZdO1cSsx0seJzT7DAwsy/T2+dgcxT78ZwJ0g+ArLZK5o8hHvlxR8fLpmsXNkHQ2jub9biv5ga+4BqGIpxA33hCcrGsVXo8+lX9z53A0kWAwLOw/VUU6OmClbq9acQ/HssC9mQ2kgD/lCu2ndSPR/XpOepFVd+Z6i654XtB4QBhjXkA8O0gvctJ2AFttwsaEINQokgcN2Cgtuwry8IGnCPNExlHiYUuRa+0x6aH+o2Mvko34Di1jaEJS0+9qxPiRmMDLamyKWehqOiIDULv1hF3zluYAnBc4pC5fuT13//CFL74UAi6KfooYvZIuk3qV7TXEjC/gsXF3t/pAyH7r3Q=='
	}

	cron { 'Back up of Puppet Config':
	command => '/usr/bin/rsync -az /home/puppet/ /puppet-backup/',
	hour => '04',
	minute => '00',
	}
#########################

	nginx::website { 'cat-pictures':
        site_domain => 'cat-pictures.com',
        }
	nginx::website { 'adorable-animals':
	site_domain => 'adorable-animals.com',
	}
	nginx::website { 'dog-pictures':
	site_domain => 'dog-pictures.com',
	}

################################ For Http ##################

#        file { "/var/www/html/${site_name}/index.html":
#        source => 'puppet:///modules/httpd/index.html',
#        }

        httpd::website { 'cat-pictures':
        site_domain => 'cat-pictures.com',
        }
########################################################




}

node 'pclient' {
	include nginx
	include httpd
	#include git
	include ssh
	include labdns
	include epel

$nagios_server = 'pserver'
	include nagiosclient

	user { 'git':
        ensure => present,
        comment => 'Git Users manage by puppet',
        home => '/home/git',
        managehome => true,
        }

	cron { 'Back up of Puppet Config':
        command => '/usr/bin/rsync -az /home/git /puppet-backup/',
        hour => '04',
        minute => '00',
        }
	
	cron { 'Git Pull':
        command => '/usr/local/bin/pull-updates',
        hour => '*',
        minute => '*/5',
	user => 'git'
        }
################################ For Http ##################

	file { "/var/www/html/${site_name}/index.html":
        source => 'puppet:///modules/httpd/index.html',
        }

	httpd::website { 'pclient':
        site_domain => 'pclient.vms.spastp.cisco.com',
        }
#########   End HTTP      ###############################################

######################### Ngix V.Host ####################

        nginx::website { 'cat-pictures':
        site_domain => 'cat-pictures.com',
        }



}
###################     RTP Lab              ##########################################################

node 'base'{
	include epel
        include nagioscron
	$nagios_server = '13.23.196.100'
        include nagiosclient
	}
#node /^web\d+\.example\.com$/ { }
#	node /^ktp-cms\d+\$/ { }
	
	node 'ktp-cms1' inherits 'base'{
	}
	node 'ktp-cms2' inherits 'base'{
	}
	node 'ktp-cms3' inherits 'base'{
	}
	node 'ktp-cms4' inherits 'base'{
	}
	node 'ktp-cms5' inherits 'base'{
	}
	node 'ktp-cms6' inherits 'base'{
	}
	node 'ktp-web1' inherits 'base'{
	}

	node 'vms-dns' inherits 'base'{ }
	node 'helpdesk' inherits 'base'{ } #Request Tracker
	node 'smtp1' inherits 'base'{ } #Request Tracker

################### Below is NagiOS Server ###############################
node 'rtp-nms' {
	include nagioscron
	include nagios

	nagios::addclient { 'ktp-cms1':
        site_domain => '13.23.201.133',
        }

	nagios::addclient { 'ktp-cms2':
        site_domain => '13.23.201.135',
        }
		
	nagios::addclient { 'ktp-cms3':
        site_domain => '13.23.201.137',
        }
		
	nagios::addclient { 'ktp-cms4':
        site_domain => '13.23.201.139',
        }
		
	nagios::addclient { 'ktp-cms5':
        site_domain => '13.23.201.141',
        }
		
	nagios::addclient { 'ktp-cms6':
        site_domain => '13.23.201.142',
        }
		
	nagios::addclient { 'ktp-web1':
        site_domain => '13.23.201.146',
        }
############ Others ######################

	nagios::addclient { 'vms-dns':
        site_domain => '10.122.90.11',
        }
		
	nagios::addclient { 'smtp1':
        site_domain => '10.122.90.25',
        }
		
	nagios::addclient { 'ci-01':
        site_domain => '10.122.90.10',
        }
		
	nagios::addclient { 'JRebel':
        site_domain => '10.122.90.18',
        }
		
	nagios::addclient { 'DHCP':
        site_domain => '10.122.90.22',
        }
		
	nagios::addclient { 'ktp-app':
        site_domain => '10.122.90.12',
        }
		
	nagios::addclient { 'rt':
        site_domain => '10.122.90.28',
        }

}
