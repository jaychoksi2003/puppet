class vms::service {
        service { 'rngd':
        ensure => running,
        require => Package['rng-tools'],
        enable => true,
        }
}
