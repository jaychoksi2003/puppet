class vms::install {
        package { [ 'rng-tools']:
        ensure => installed,
        }
	if $role == "vms_installer" {

	file { '/tmp/limits.conf':
        source => 'puppet:///modules/vms/limits.conf',
	}
	}
}	
