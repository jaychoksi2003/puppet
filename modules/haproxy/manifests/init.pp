class haproxy {
 package { 'haproxy':
        ensure => installed,
        }
 service { 'haproxy':
        ensure => running,
        require => Package['haproxy'],
        enable => true,
        }
}
