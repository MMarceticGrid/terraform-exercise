#!/bin/bash
apt-get update -y
apt-get install -y apache2
echo "<h1>Hello from $(hostname)</h1>"> /var/www/html/index.html
systemctl enable apache2
systemctl start apache2