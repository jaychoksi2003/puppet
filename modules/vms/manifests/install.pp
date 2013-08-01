class vms::install {
        package { [ 'rng-tools']:
        ensure => installed,
        }
	if $vms_role == "vms_installer" {

	file { '/tmp/limits.conf':
        source => 'puppet:///modules/vms/limits.conf',
	}
	}
}	
