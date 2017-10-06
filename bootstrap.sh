#!/usr/bin/env bash

Update () {
    echo "-- Update packages --"
    sudo apt-get update
    sudo apt-get upgrade
}

echo "-- Prepare configuration for MySQL --"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

echo "-- Install tools and helpers --"
sudo apt-get install -y python-software-properties vim htop curl git npm

echo "-- Install PPA's --"
sudo add-apt-repository ppa:chris-lea/redis-server
Update

echo "-- Install packages --"
sudo apt-get install -y apache2 mysql-server mysql-client git-core redis-server
sudo apt-get install -y php7.0 php7.0-common php7.0-dev php7.0-cli php7.0-json php7.0-opcache php7.0-cli libapache2-mod-php7.0 php7.0 php7.0-mysql php7.0-fpm php7.0-curl php7.0-gd php7.0-mcrypt php7.0-mbstring php7.0-bcmath php7.0-zip

echo "-- Configure PHP &Apache --"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini
sudo a2enmod rewrite

echo "-- Creating virtual hosts --"
sudo mkdir /vagrant/public
sudo ln -fs /vagrant/public/ /var/www/app

sudo rm -fr /etc/apache2/sites-available/000-default.conf

cat << EOF | sudo tee -a /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    DocumentRoot /var/www/app
    ServerName 127.0.0.1

    <Directory "/var/www/app">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
EOF
sudo a2ensite default.conf

echo "-- Restart Apache --"
sudo /etc/init.d/apache2 restart

echo "-- Install Composer --"
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php
sudo php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

echo "-- Install phpMyAdmin --"
wget -k https://files.phpmyadmin.net/phpMyAdmin/4.7.4/phpMyAdmin-4.7.4-english.tar.gz
sudo tar -xzvf phpMyAdmin-4.7.4-english.tar.gz -C /var/www/
sudo rm phpMyAdmin-4.7.4-english.tar.gz
sudo cp -R /var/www/phpMyAdmin-4.7.4-english /var/www/app/pma
sudo rm -fr /var/www/phpMyAdmin-4.7.4-english

#echo "-- Setup databases --"
#mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"
#mysql -uroot -proot -e "CREATE DATABASE my_database";
