class labdns {
        exec { 'Manage DNS':
	command => 'echo nameserver 10.122.90.11 > /etc/resolv.conf',
        unless => 'grep 10.122.90.11 /etc/resolv.conf',
        }

}
