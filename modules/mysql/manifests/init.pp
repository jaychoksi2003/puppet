class mysql {
        package {
                ["mysql", "mysql-server", "mysql-client"]:
                ensure => 'installed',
        }
	
	exec { "Set MySQL server root password":
        subscribe => [ Package["mysql-server"], Package["mysql-client"] ],
        refreshonly => true,
        unless => "mysqladmin -uroot -p${root_password} status",
        path => "/bin:/usr/bin",
        command => "mysqladmin -uroot password ${root_password}",
    }

    exec { "Create magento user":
      unless => "/usr/bin/mysqladmin -umagento -pmagento status",
      command => "/usr/bin/mysql -uroot -p${root_password} -e \"CREATE USER magento@'%' IDENTIFIED BY 'magento'; Grant all on *.* TO magento@'%';\"",
      require => Service["mysql"],
    }

    service { "mysql":
        require => [ Package["mysql-server"], Exec['Set MySQL server root password'] ],
        hasstatus => true,
    }	
}

