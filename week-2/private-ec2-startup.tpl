#!/bin/bash
sudo yum install -y nginx
sudo nginx
sudo bash -c 'echo "<h1>TERRAFORM WAS HERE</h1>" > /usr/share/nginx/html/index.html'
