user { 'nagios':
	ensure => present,
	shell => '/sbin/nologin',
}
