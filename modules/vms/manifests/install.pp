class vms::install {
        package { [ 'rng-tools']:
        ensure => installed,
        }
	if $vms_role == "vms_installer" {
		package { 'vms_installer-5.0.1-77253':
		ensure => 'present',
			}
	}
	if $vms_role == "vms_sso" {
		package { [ 'vms_base', 'vms_admin', 'vms_keymanagement']:
                ensure => 'present',
                        }
        }
	
	if $vms_role == "vms_cm" {
		package { [ 'vms_base', 'vms_server_standard', 'vms_cms']:
                ensure => 'present',
                        }
        }
}
