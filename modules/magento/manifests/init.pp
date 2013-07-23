class magento( $db_username, $db_password, $version, $admin_username, $admin_password, $use_rewrites, $document_root) {

	exec { "create-magentodb-db":
        unless => "/usr/bin/mysql -uroot -p${mysql::root_password} magentodb",
        command => "/usr/bin/mysqladmin -uroot -p${$mysql::root_password} create magentodb",
        require => [Service["mysqld"]]
  	}

	exec { "grant-magentodb-db-all":
        unless => "/usr/bin/mysql -u${db_username} -p${db_password} magentodb",
        command => "/usr/bin/mysql -uroot -p${$mysql::root_password} -e \"grant all on *.* to magento@'%' identified by '${db_password}' WITH GRANT OPTION;\"",
        require => [Service["mysqld"], Exec["create-magentodb-db"]]
  	}

	exec { "grant-magentodb-db-localhost":
        unless => "/usr/bin/mysql -u${db_username} -p${db_password} magentodb",
        command => "/usr/bin/mysql -uroot -p${$mysql::root_password} -e \"grant all on *.* to magento@'localhost' identified by '${db_password}' WITH GRANT OPTION;\"",
        require => Exec["grant-magentodb-db-all"]
  	}

	exec { "download-magento":
	cwd => "/tmp",
	command => "/usr/bin/wget http://pserver.vms.spastp.cisco.com/enterprise-${version}.tar.gz",
	creates => "/tmp/enterprise-${version}.tar.gz",
  	}

	file { ${document_root}:
        ensure => "directory",
        mode => 755,
        owner => "apache",
        group  => "apache",
	recurse => "true",
        }

	
	exec { "untar-magento":
	cwd => ${document_root},
	command => "/bin/tar xvzf /tmp/enterprise-${version}.tar.gz",
	require => [Exec["download-magento"]]
	}	

}
