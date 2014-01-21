class php {
        package {
                ["php", "php-cli", "php-common", "php-mysql", "php-gd", "php-intl", "php-mcrypt", "php-mbstring"]:
                ensure => '5.3.27-2.w5',
        }
}

