class vms::install {
        package { [ 'rng-tools']:
        ensure => installed,
        }

}	
