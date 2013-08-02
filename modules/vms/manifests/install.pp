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
	if $vms_role == "vms_em" {
		package { [ 'vms_base', 'vms_server_standard']:
                ensure => 'present',
                        }
		package { [ 'vms_entitlement']:
		ensure => 'present',
		require => Package[ 'vms_server_standard'],
		}
        }
	
	if $vms_role == "vms_wf" {
		package { [ 'vms_base', 'vms_server_esb', 'vms_workflow', 'vms_ocesb_epg']:
               ensure => 'present',
                        }
        }
	
#	if $vms_role == "vms_solr" {
#		package { [ 'vms_base', 'vms_epg', 'vms_search_master', 'vms_search_config']:
#               ensure => 'present',
#                        }
#        }
}
