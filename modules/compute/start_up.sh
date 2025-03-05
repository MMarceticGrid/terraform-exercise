#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y apache2
sudo echo "<h1>Hello from $(hostname)</h1>"> /var/www/html/index.html
echo "<h1>Hello from $(hostname)</h1>" | sudo tee /var/www/html/index.html > /dev/null
sudo systemctl enable apache2
sudo systemctl start apache2