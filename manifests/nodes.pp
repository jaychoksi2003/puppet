node 'pserver' {
	include nginx
	include httpd
	include git

	user { 'jboss':
	ensure => present,
	comment => 'Jboss Users manage by puppet',
	home => '/opt/jboss',
	managehome => true,
	}


}
node 'pclient' {
include nginx
include httpd
#include git
include ssh
}
