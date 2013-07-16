class ssh {
	package { 'openssh-server':
        ensure => latest
	} 
	service { 'sshd':
	ensure => running,
	enable => true,
	require   => Package['openssh-server'],
	}

	file { '/etc/ssh/sshd_config':
	source => 'puppet:///modules/ssh/sshd_config',
	owner => root,
	group   => root,
        mode    => 600,
	notify => Service['sshd'],
	}

	ssh_authorized_key { 'Rodolfo Romero':
	user => 'root',
	type => 'rsa',
	key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC4Z6nSamtxORA8hBzjLJqML2QAh9rcW3VjplwVhyZWQh8BvCGDA0cetzyOcOAZs1MULWOxmAbB1wOjr4Ct+v4HWXpCpfC5wwwy6VMDt6/EIsldDPA3/Cg8/bxWeRJUm25D1FBuI3DhyNS4uW5SuHvUbLPxW7S+1XU8/B0S9Eu8TYD7Oa8/v4iHNAtbme1jtx9ALSRKFBl2UBB9hFbJKTa7N5rEj/+yeTt/w6CZr7WLqVaAKB7F8OTsinLKERoLs+bwm6rK7R8TO2Ho34t0BsDVsNCs69vE363jokuXVGvB1BQZYXJpaDJmUV+LEfLSOmFJe8i6i69QuijYKjFSIWjJ',
	}
	
	ssh_authorized_key { 'Jay-Cisco':
	user => 'root',
	type => 'rsa',
	key => 'AAAAB3NzaC1yc2EAAAABJQAAAIBRg9pBhApa62AuWIgyEO0552itbXyh8wP8PnqU
bZI4d4YTQUSsG7m17o7o46X4or6ndzbhbgnIxz13xelDUYuj09ycVk2SXzAFp+Ro
A9Xa//z4/kmA2PklAaFNp9w8TAYxcSSjVE2GjgY5cikvmMDEw2R4T0/o2FmxpbUT
uO02iQ==',
	}
}
