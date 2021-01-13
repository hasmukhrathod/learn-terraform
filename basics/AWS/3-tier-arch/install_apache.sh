#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo chkconfig httpd on
sudo echo "<h1>Deployed via Terraform</h1>" > /var/www/html/index.html
sudo service httpd start
