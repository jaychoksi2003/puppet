class vms::service {
        service { 'rngd':
        ensure => running,
        require => File['/etc/sysconfig/rngd'],
        enable => true,
        }
}
