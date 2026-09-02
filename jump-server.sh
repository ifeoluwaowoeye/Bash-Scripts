#!/bin/bash
set -e
# changing the Server hostname
#=============================
sudo hostnamectl set-hostname Jumper-Server-01

# updating the server
#====================
sudo apt update -y
sudo apt upgrade -y

# create a folder to mount to efs
#================================
mkdir -p /home/ubuntu/webserver

# installing EFS client dependencies
#====================================
sudo apt -y install nfs-common stunnel4 git binutils

# adding the efs acces point to fstab
#=====================================
sudo tee -a /etc/fstab > /dev/null <<EOF
fs-0ba8b49ca60a32814.efs.us-east-2.amazonaws.com:/ /home/ubuntu/webserver nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0
EOF

# mount efs
#===========
sudo mount -a

# connect to datadog
#===================
DD_API_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
DD_SITE="uk1.datadoghq.com" \
DD_APM_INSTRUMENTATION_ENABLED=host \
DD_ENV=dev \
DD_APM_INSTRUMENTATION_LIBRARIES=java:1,python:4,js:5,php:1,dotnet:3,ruby:2,nginx:1 \
DD_RUM_ENABLED=true \
DD_RUM_APPLICATION_ID=3471347a-76c4-43e7-88d7-066c0be95494 \
DD_RUM_CLIENT_TOKEN=pubccc2e53d6b0ad11b548bb2a12a96f0de \
DD_RUM_REMOTE_CONFIGURATION_ID=c37fcd76-65e0-438c-ab76-72da55ea4a65 \
DD_RUM_SITE=uk1.datadoghq.com \
bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)"