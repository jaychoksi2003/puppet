class vms::config {
	file { '/etc/security/limits.conf':
	source => 'puppet:///modules/vms/limits.conf',
	owner => 'root',
	group => 'root',
	mode => '644',
	}

	file { '/etc/yum.repos.d/vms.repo':
        source => 'puppet:///modules/vms/vms.repo',
        }
}
