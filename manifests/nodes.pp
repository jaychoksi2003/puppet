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

node 'helpdesk' {
        include epel
$nagios_server = 'pserver'
        include nagiosclient
}

node 'rtp-nms' {
	include nagios
}
