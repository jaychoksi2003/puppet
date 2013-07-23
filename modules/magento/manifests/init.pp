class magento( $db_username, $db_password, $version, $admin_username, $admin_password, $use_rewrites) {

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

}
