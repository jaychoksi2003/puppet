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
	key => 'AAAAB3NzaC1yc2EAAAABJQAAAIBRg9pBhApa62AuWIgyEO0552itbXyh8wP8PnqUbZI4d4YTQUSsG7m17o7o46X4or6ndzbhbgnIxz13xelDUYuj09ycVk2SXzAFp+RoA9Xa//z4/kmA2PklAaFNp9w8TAYxcSSjVE2GjgY5cikvmMDEw2R4T0/o2FmxpbUTuO02iQ==',
	}

	ssh_authorized_key { 'ci01.vms.spastp':
        user => 'root',
        type => 'rsa',
        key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAqTC7EKFm5tVsr3JzEd5o7MViDo1XvODN1tl6OmW/XG35IUaoPAqVrsL07Kz0rNPhpmaCPVyX1pNkUBBTh85NzAKhnjII9ohGrWIJHcGiajnktyJ9QvAkOildbDaIeEK2Ppu1DS7zN6XFL7QePOJJPvAt4Y7d7EJ/FN5o6+aha6CxrH5azNxR89kxK3fC1smu0OtxR0FOgoK02idnKzxvRudaYi6lMwH7pq7hm6NAcPaGYYMKfynrXJwkzBx1l4Hjg5ksk9vn+jUDhHlYaeQoiuVPxEAq1q82fzWQ2cZ3rmQckIPayuTbUJds1U+PHpaEjUMLRtIcCFWx/vBkYotXXw==',
	}

	ssh_authorized_key { 'vms-as-ci':
        user => 'root',
        type => 'rsa',
	key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAvRZQMO4ZaT8ZHxZ/oPPzOCP1Cf2/99OaoyhbuASeJmCZXZqcSfklL6PWcnGFoVxdRFi6/UTJmOTFYpE/ff95DkWIGFL86zsUVkhb2BLopMD8IoEqEyHBZq+ZRsB84p5bHTuBWdofGpCZVTWjqsI+Y5gn4+dNmW4MhueBaoxWL23RW+7/7adKHZt3JNr1slCSL/t72L4ExhtwcKjX2PAxEWfGAPzcs+ABvVkNc9KNaV6sBo7Q/XYbiIWBBwIV4aaFfY7BHlgftRYCuc/1EtnV1FrMSxsjT5gsDb/4/CMV4jiq53BNXrndpYUl9nuBnM/aciAgAo2FKgaUnVPo0EHuiw=='
	}
}
