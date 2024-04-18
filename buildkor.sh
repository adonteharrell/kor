#!/bin/bash

#Set enviroment variables
VID_DIR="/videos"
WIN_USER="Dummy"
WIN_PW="youdumb"
WIN_DIR="//10.0.0.236/Videos2"

#Install podman and enable service.
yum install podman -y
systemctl enable --now podman

yum install docker -y
systemctl enable --now docker

#Install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose

#Create your local video directory 
mkdir $VID_DIR

#Mount your Windows drive to local video directory
yum install cifs-utils -y
sudo mount -t cifs $WIN_DIR $VID_DIR -o username=$WIN_USER,password=$WIN_PW

# Set SELinux to permissive if needed 
setenforce 0

#Build korcese environment
docker-compose up -d 

#Start container and move movies
podman exec -it korcese sh convert.sh 
