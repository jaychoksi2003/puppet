define nagios::cfg( $site_domain ) {
        include nagios
        $site_name = $name

        file { "/etc/nagios/objects/servers/${site_name}.cfg":
        content => template('nagios/others.cfg.erb'),
        notify => Service['nagios'],
        }
