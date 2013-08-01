class vms::install {
        package { [ 'rng-tools']:
        ensure => installed,
        }
	if $vms_role == "vms_installer" {
		package => 'vms_installer-5.0.1-77253',
		ensure => 'present',
	}
}	
