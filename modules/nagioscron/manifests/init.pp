cron { 'Git Pull':
        command => '/usr/local/bin/pull-updates',
        hour => '*',
        minute => '*/5',
        user => 'root'
        }

