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
	
	node 'ktp-cms1' inherits 'base'{ }
	node 'ktp-cms2' inherits 'base'{ }
	node 'ktp-cms3' inherits 'base'{ }
	node 'ktp-cms4' inherits 'base'{ }
	node 'ktp-cms5' inherits 'base'{ }
	node 'ktp-cms6' inherits 'base'{ }
	node 'ktp-web1' inherits 'base'{ }
	

	node 'vms-dns' inherits 'base'{ }
	node 'helpdesk' inherits 'base'{ } #Request Tracker
	node 'smtp1' inherits 'base'{ } 
	node 'ci01' inherits 'base'{ } 
	node 'JRebel' inherits 'base'{ } 
	node 'dhcp1' inherits 'base'{ } 
	node 'ktp-app' inherits 'base'{ } 

################ RefSol Servers ##############################
node 'refsol-perf-lb1' inherits 'base'{ }
node 'refsol-perf-wf1' inherits 'base'{ }
node 'refsol-perf-wf2' inherits 'base'{ }
node 'refsol-perf-sso1' inherits 'base'{ }
node 'refsol-perf-sso2' inherits 'base'{ }
node 'refsol-perf-ent1' inherits 'base'{ }
node 'refsol-perf-ent2' inherits 'base'{ }
node 'refsol-perf-ent3' inherits 'base'{ }
node 'refsol-perf-ent4' inherits 'base'{ }
node 'refsol-perf-cm1' inherits 'base'{ }
node 'refsol-perf-cm2' inherits 'base'{ }
node 'refsol-perf-lm1' inherits 'base'{ }
node 'refsol-perf-lm2' inherits 'base'{ }
node 'refsol-perf-solr1' inherits 'base'{ }
node 'refsol-perf-solr2' inherits 'base'{ }
node 'refsol-perf-sm1' inherits 'base'{ }
node 'refsol-perf-sm2' inherits 'base'{ }
node 'refsol-perf-sm3' inherits 'base'{ }
node 'refsol-perf-sm4' inherits 'base'{ }
node 'refsol-perf-sif1' inherits 'base'{ }
node 'refsol-perf-sif2' inherits 'base'{ }
node 'refsol-perf-sif3' inherits 'base'{ }
node 'refsol-perf-sif4' inherits 'base'{ }
node 'refsol-perf-mcsif1' inherits 'base'{ }
node 'refsol-perf-mcsif2' inherits 'base'{ }
node 'refsol-perf-web1' inherits 'base'{ }
node 'refsol-perf-web2' inherits 'base'{ }
node 'refsol-perf-mag1' inherits 'base'{ }
node 'refsol-perf-mag2' inherits 'base'{ }
node 'refsol-perf-mag3' inherits 'base'{ }
node 'refsol-perf-mag4' inherits 'base'{ }
node 'refsol-perf-mcmag1' inherits 'base'{ }
node 'refsol-perf-mysql1' inherits 'base'{ }
node 'refsol-perf-mysql2' inherits 'base'{ }
node 'refsol-perf-rac1' inherits 'base'{ }
node 'refsol-perf-rac2' inherits 'base'{ }
node 'refsol-qc-lb' inherits 'base'{ }
node 'refsol-qc-wf1' inherits 'base'{ }
node 'refsol-qc-wf2' inherits 'base'{ }
node 'refsol-qc-sso1' inherits 'base'{ }
node 'refsol-qc-sso2' inherits 'base'{ }
node 'refsol-qc-ent1' inherits 'base'{ }
node 'refsol-qc-ent2' inherits 'base'{ }
node 'refsol-qc-cm1' inherits 'base'{ }
node 'refsol-qc-cm2' inherits 'base'{ }
node 'refsol-qc-lm1' inherits 'base'{ }
node 'refsol-qc-lm2' inherits 'base'{ }
node 'refsol-qc-solr1' inherits 'base'{ }
node 'refsol-qc-solr2' inherits 'base'{ }
node 'refsol-qc-sm1' inherits 'base'{ }
node 'refsol-qc-sm2' inherits 'base'{ }
node 'refsol-qc-sif1' inherits 'base'{ }
node 'refsol-qc-sif2' inherits 'base'{ }
node 'refsol-qc-mcsif1' inherits 'base'{ }
node 'refsol-qc-mcsif2' inherits 'base'{ }
node 'refsol-qc-web1' inherits 'base'{ }
node 'refsol-qc-web2' inherits 'base'{ }
node 'refsol-qc-mag1' inherits 'base'{ }
node 'refsol-qc-mag2' inherits 'base'{ }
node 'refsol-qc-mcmag1' inherits 'base'{ }
node 'refsol-qc-mysql1' inherits 'base'{ }
node 'refsol-qc-mysql2' inherits 'base'{ }
node 'refsol-sit-lb' inherits 'base'{ }
node 'refsol-sit-wf1' inherits 'base'{ }
node 'refsol-sit-cm1' inherits 'base'{ }
node 'refsol-sit-sm1' inherits 'base'{ }
node 'refsol-sit-sif1' inherits 'base'{ }
node 'refsol-sit-mag1' inherits 'base'{ }
node 'refsol-dev-lb' inherits 'base'{ }
node 'refsol-dev-wf1' inherits 'base'{ }
node 'refsol-dev-wf2' inherits 'base'{ }
node 'refsol-dev-sso1' inherits 'base'{ }
node 'refsol-dev-ent1' inherits 'base'{ }
node 'refsol-dev-cm1' inherits 'base'{ }
node 'refsol-dev-lm1' inherits 'base'{ }
node 'refsol-dev-solr1' inherits 'base'{ }
node 'refsol-dev-sm1' inherits 'base'{ }
node 'refsol-dev-sm2' inherits 'base'{ }
node 'refsol-dev-sif1' inherits 'base'{ }
node 'refsol-dev-sif2' inherits 'base'{ }
node 'refsol-dev-mcsif1' inherits 'base'{ }
node 'refsol-dev-web1' inherits 'base'{ }
node 'refsol-dev-web2' inherits 'base'{ }
node 'refsol-dev-mag1' inherits 'base'{ }
node 'refsol-dev-mcmag1' inherits 'base'{ }
node 'refsol-dev-mysql' inherits 'base'{ }


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
################## Ref. Solu. ##############

nagios::addclient { 'refsol-perf-lb1':
        site_domain => '10.122.90.13',
        }
                                
nagios::addclient { 'refsol-perf-wf1':
        site_domain => '13.23.201.10',
        }
                                
nagios::addclient { 'refsol-perf-wf2':
        site_domain => '13.23.201.11',
        }
                                
nagios::addclient { 'refsol-perf-sso1':
        site_domain => '13.23.201.12',
        }
                                
nagios::addclient { 'refsol-perf-sso2':
        site_domain => '13.23.201.13',
        }
                                
nagios::addclient { 'refsol-perf-ent1':
        site_domain => '13.23.201.14',
        }
                                
nagios::addclient { 'refsol-perf-ent2':
        site_domain => '13.23.201.15',
        }
                                
nagios::addclient { 'refsol-perf-ent3':
        site_domain => '13.23.201.16',
        }
                                
nagios::addclient { 'refsol-perf-ent4':
        site_domain => '13.23.201.17',
        }
                                
nagios::addclient { 'refsol-perf-cm1':
        site_domain => '13.23.201.18',
        }
                                
nagios::addclient { 'refsol-perf-cm2':
        site_domain => '13.23.201.19',
        }
                                
nagios::addclient { 'refsol-perf-lm1':
        site_domain => '13.23.201.20',
        }
                                
nagios::addclient { 'refsol-perf-lm2':
        site_domain => '13.23.201.21',
        }
                                
nagios::addclient { 'refsol-perf-solr1':
        site_domain => '13.23.201.22',
        }
                                
nagios::addclient { 'refsol-perf-solr2':
        site_domain => '13.23.201.23',
        }
                                
nagios::addclient { 'refsol-perf-sm1':
        site_domain => '13.23.201.24',
        }
                                
nagios::addclient { 'refsol-perf-sm2':
        site_domain => '13.23.201.25',
        }
                                
nagios::addclient { 'refsol-perf-sm3':
        site_domain => '13.23.201.26',
        }
                                
nagios::addclient { 'refsol-perf-sm4':
        site_domain => '13.23.201.27',
        }
                                
nagios::addclient { 'refsol-perf-sif1':
        site_domain => '13.23.201.30',
        }
                                
nagios::addclient { 'refsol-perf-sif2':
        site_domain => '13.23.201.31',
        }
                                
nagios::addclient { 'refsol-perf-sif3':
        site_domain => '13.23.201.32',
        }
                                
nagios::addclient { 'refsol-perf-sif4':
        site_domain => '13.23.201.33',
        }
                                
nagios::addclient { 'refsol-perf-mcsif1':
        site_domain => '13.23.201.34',
        }
                                
nagios::addclient { 'refsol-perf-mcsif2':
        site_domain => '13.23.201.35',
        }
                                
nagios::addclient { 'refsol-perf-web1':
        site_domain => '13.23.201.36',
        }
                                
nagios::addclient { 'refsol-perf-web2':
        site_domain => '13.23.201.37',
        }
                                
nagios::addclient { 'refsol-perf-mag1':
        site_domain => '13.23.201.38',
        }
                                
nagios::addclient { 'refsol-perf-mag2':
        site_domain => '13.23.201.39',
        }
                                
nagios::addclient { 'refsol-perf-mag3':
        site_domain => '13.23.201.40',
        }
                                
nagios::addclient { 'refsol-perf-mag4':
        site_domain => '13.23.201.41',
        }
                                
nagios::addclient { 'refsol-perf-mcmag1':
        site_domain => '13.23.201.42',
        }
                                
nagios::addclient { 'refsol-perf-mysql1':
        site_domain => '13.23.201.43',
        }
                                
nagios::addclient { 'refsol-perf-mysql2':
        site_domain => '13.23.201.44',
        }
                                
nagios::addclient { 'refsol-perf-rac1':
        site_domain => '13.23.201.45',
        }
                                
nagios::addclient { 'refsol-perf-rac2':
        site_domain => '13.23.201.46',
        }
                                
nagios::addclient { 'refsol-qc-lb':
        site_domain => '10.122.90.7',
        }
                                
nagios::addclient { 'refsol-qc-wf1':
        site_domain => '13.23.200.35',
        }
                                
nagios::addclient { 'refsol-qc-wf2':
        site_domain => '13.23.200.36',
        }
                                
nagios::addclient { 'refsol-qc-sso1':
        site_domain => '13.23.200.37',
        }
                                
nagios::addclient { 'refsol-qc-sso2':
        site_domain => '13.23.200.38',
        }
                                
nagios::addclient { 'refsol-qc-ent1':
        site_domain => '13.23.200.39',
        }
                                
nagios::addclient { 'refsol-qc-ent2':
        site_domain => '13.23.200.40',
        }
                                
nagios::addclient { 'refsol-qc-cm1':
        site_domain => '13.23.200.41',
        }
                                
nagios::addclient { 'refsol-qc-cm2':
        site_domain => '13.23.200.42',
        }
                                
nagios::addclient { 'refsol-qc-lm1':
        site_domain => '13.23.200.43',
        }
                                
nagios::addclient { 'refsol-qc-lm2':
        site_domain => '13.23.200.44',
        }
                                
nagios::addclient { 'refsol-qc-solr1':
        site_domain => '13.23.200.45',
        }
                                
nagios::addclient { 'refsol-qc-solr2':
        site_domain => '13.23.200.46',
        }
                                
nagios::addclient { 'refsol-qc-sm1':
        site_domain => '13.23.200.47',
        }
                                
nagios::addclient { 'refsol-qc-sm2':
        site_domain => '13.23.200.48',
        }
                                
nagios::addclient { 'refsol-qc-sif1':
        site_domain => '13.23.200.51',
        }
                                
nagios::addclient { 'refsol-qc-sif2':
        site_domain => '13.23.200.52',
        }
                                
nagios::addclient { 'refsol-qc-mcsif1':
        site_domain => '13.23.200.53',
        }
                                
nagios::addclient { 'refsol-qc-mcsif2':
        site_domain => '13.23.200.54',
        }
                                
nagios::addclient { 'refsol-qc-web1':
        site_domain => '13.23.200.55',
        }
                                
nagios::addclient { 'refsol-qc-web2':
        site_domain => '13.23.200.56',
        }
                                
nagios::addclient { 'refsol-qc-mag1':
        site_domain => '13.23.200.57',
        }
                                
nagios::addclient { 'refsol-qc-mag2':
        site_domain => '13.23.200.58',
        }
                                
nagios::addclient { 'refsol-qc-mcmag1':
        site_domain => '13.23.200.59',
        }
                                
nagios::addclient { 'refsol-qc-mysql1':
        site_domain => '13.23.200.60',
        }
                                
nagios::addclient { 'refsol-qc-mysql2':
        site_domain => '13.23.200.61',
        }
                                
nagios::addclient { 'refsol-sit-lb':
        site_domain => '10.122.90.6',
        }
                                
nagios::addclient { 'refsol-sit-wf1':
        site_domain => '13.23.200.29',
        }
                                
nagios::addclient { 'refsol-sit-cm1':
        site_domain => '13.23.200.30',
        }
                                
nagios::addclient { 'refsol-sit-sm1':
        site_domain => '13.23.200.31',
        }
                                
nagios::addclient { 'refsol-sit-sif1':
        site_domain => '13.23.200.32',
        }
                                
nagios::addclient { 'refsol-sit-mag1':
        site_domain => '13.23.200.33',
        }
                                
nagios::addclient { 'refsol-dev-lb':
        site_domain => '10.122.90.5',
        }

nagios::addclient { 'refsol-dev-wf1':
        site_domain => '13.23.200.11',
        }
                                
nagios::addclient { 'refsol-dev-wf2':
        site_domain => '13.23.200.12',
        }
                                
nagios::addclient { 'refsol-dev-sso1':
        site_domain => '13.23.200.13',
        }
                                
nagios::addclient { 'refsol-dev-ent1':
        site_domain => '13.23.200.14',
        }
                                
nagios::addclient { 'refsol-dev-cm1':
        site_domain => '13.23.200.15',
        }
                                
nagios::addclient { 'refsol-dev-lm1':
        site_domain => '13.23.200.16',
        }
                                
nagios::addclient { 'refsol-dev-solr1':
        site_domain => '13.23.200.17',
        }
                                
nagios::addclient { 'refsol-dev-sm1':
        site_domain => '13.23.200.18',
        }
                                
nagios::addclient { 'refsol-dev-sm2':
        site_domain => '13.23.200.19',
        }
                                
nagios::addclient { 'refsol-dev-sif1':
        site_domain => '13.23.200.21',
        }
                                
nagios::addclient { 'refsol-dev-sif2':
        site_domain => '13.23.200.22',
        }
                                
nagios::addclient { 'refsol-dev-mcsif1':
        site_domain => '13.23.200.23',
        }
                                
nagios::addclient { 'refsol-dev-web1':
        site_domain => '13.23.200.24',
        }
                                
nagios::addclient { 'refsol-dev-web2':
        site_domain => '13.23.200.25',
        }
                                
nagios::addclient { 'refsol-dev-mag1':
        site_domain => '13.23.200.26',
        }
                                
nagios::addclient { 'refsol-dev-mcmag1':
        site_domain => '13.23.200.27',
        }
                                
nagios::addclient { 'refsol-dev-mysql':
        site_domain => '13.23.200.28',
        }




}
