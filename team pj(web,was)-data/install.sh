#! /bin/bash

sudo su -
yum install -y httpd
echo "test index" > /var/www/html/index.html
systemctl enable --now httpd