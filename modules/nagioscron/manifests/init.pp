class nagioscron {
        
	cron { 'Git Pull':
	command => '/usr/local/bin/pull-updates',
	hour => '*',
        minute => '*/5',
        user => 'root',
	environment =>  'MAILTO=jchoksi@cisco.com',
        }

}

