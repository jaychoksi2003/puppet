class magento( $db_name, $db_username, $db_password, $version, $admin_username, $admin_password, $use_rewrites, $document_root, $magento_url, $admin_email) {

	exec { "create-magentodb-db":
        unless => "/usr/bin/mysql -uroot -p${mysql::root_password} ${db_name}",
        command => "/usr/bin/mysqladmin -uroot -p${$mysql::root_password} create ${db_name}",
        require => [Service["mysqld"]]
  	}

	exec { "grant-magentodb-db-all":
        unless => "/usr/bin/mysql -u${db_username} -p${db_password} ${db_name}",
        command => "/usr/bin/mysql -uroot -p${$mysql::root_password} -e \"grant all on *.* to magento@'%' identified by '${db_password}' WITH GRANT OPTION;\"",
        require => [Service["mysqld"], Exec["create-magentodb-db"]]
  	}

	exec { "grant-magentodb-db-localhost":
        unless => "/usr/bin/mysql -u${db_username} -p${db_password} ${db_name}",
        command => "/usr/bin/mysql -uroot -p${$mysql::root_password} -e \"grant all on *.* to magento@'localhost' identified by '${db_password}' WITH GRANT OPTION;\"",
        require => Exec["grant-magentodb-db-all"]
  	}

	exec { "download-magento":
	cwd => "/tmp",
	command => "/usr/bin/wget http://pserver.vms.spastp.cisco.com/enterprise-${version}.tar.gz",
	creates => "/tmp/enterprise-${version}.tar.gz",
  	}

	exec { "untar-magento":
	cwd => "${document_root}",
	command => "/bin/tar xvzf /tmp/enterprise-${version}.tar.gz",
	creates => "${document_root}/magento",
	require => [Exec["download-magento"]]
	}

	file { "${document_root}":
        ensure => "directory",
        mode => 755,
        owner => "apache",
        group  => "apache",
#	recurse => "true",
	require => [Exec["untar-magento"]]
        }
	
	host { 'magento.localhost':
        ip => '127.0.0.1',
	}

	exec { "install-magento":
	cwd => "${document_root}/magento",
	creates => "${document_root}/magento/app/etc/local.xml",
        command => "/usr/bin/php -f install.php -- \
        --license_agreement_accepted \"yes\" \
        --locale \"en_US\" \
        --timezone \"America/Los_Angeles\" \
        --default_currency \"USD\" \
        --db_host \"localhost\" \
        --db_name \"${db_name}\" \
        --db_user \"${db_username}\" \
        --db_pass \"${db_password}\" \
        --url \"http://${magento_url}/magento\" \
        --use_rewrites \"${use_rewrites}\" \
        --use_secure \"no\" \
        --secure_base_url \"http://${magento_url}/magento\" \
        --use_secure_admin \"no\" \
        --skip_url_validation \"yes\" \
        --admin_firstname \"Cisco\" \
        --admin_lastname \"Cisco\" \
        --admin_email \"${admin_email}\" \
        --admin_username \"${admin_username}\" \
        --admin_password \"${admin_password}\"",
        require => [ Exec["create-magentodb-db"]],
        }

#       exec { "register-magento-channel":
#       cwd     => "${document_root}/magento",
#    onlyif  => "/usr/bin/test ${document_root}/magento/mage list-channels | wc -l` -lt 2",
#    command => "${document_root}/magento/mage mage-setup",
#    require => [Exec["install-magento"]]
#  }


}
