#!/bin/bash
sleep 60
apt update

# install Apache2
apt -y install apache2

# write some HTML
echo \<center\>\<h1\>Hello From Demo App\</h1\>\<br/\>\</center\> > /var/www/html/index.html

# restart Apache
apachectl restart
