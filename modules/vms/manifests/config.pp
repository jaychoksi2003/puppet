class vms::config {
	file { '/etc/security/limits.conf':
	source => 'puppet:///modules/vms/limits.conf',
	owner => 'root',
	group => 'root',
	mode => '644',
	}

	file { '/etc/security/limits.d/90-nproc.conf':
	source => 'puppet:///modules/vms/90-nproc.conf',
	owner => 'root',
	group => 'root',
	mode => '644',
	}

	file { '/etc/sysconfig/rngd':
        source => 'puppet:///modules/vms/rngd',
	require => Package[ 'rng-tools'],
	notify => Service[ 'rngd'],
	owner => 'root',
        group => 'root',
        mode => '640',
        }

	file { '/etc/yum.repos.d/vms.repo':
        source => 'puppet:///modules/vms/vms.repo',
        }
}
