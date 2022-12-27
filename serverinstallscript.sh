#!/bin/bash
echo "Running this script will install everything required to get a TAK Server operational within Rocky Linux. Some portions of the install may take a while. Please be patient."
read -p "Press ENTER to begin."

# Update OS
sudo yum update -y

# Increase system limit for number of concurrent TCP connections
echo -e"* soft nofile 32768\n* hard nofile 32768" |sudo  tee --append /etc/security/limits.conf>/dev/null

# Install EPEL
sudo yum install epel-release -y

# Install PostgreSQL and PostGIS packages
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Update
sudo dnf update -y

# Enable PowerTools
sudo dnf config-manager --set-enabled powertools

# Disable system default PostgreSQL
sudo dnf -qy module disable postgresql

echo "If prompted, press y and then enter to import the GPG key"

# Install PostgreSQL 15
sudo dnf install -y postgresql15-server

# Install Java 11
sudo yum install java-11-openjdk-devel -y

# Install Python and PIP
sudo dnf install python39 -y

sudo dnf install python39-pip

# Upgrade PIP
sudo pip3 install --upgrade pip

wait

# Install GDown
pip install gdown

# Begin Google Drive TAK Server download

echo "*****************************************"
echo "Using Google Drive Method"
echo "*****************************************"
echo ""
echo "WHAT IS YOUR FILE ID ON GOOGLE DRIVE?"
echo "(Right click > Get Link > Allow Sharing to anyone with link > Open share link > 'https://drive.google.com/file/d/<YOUR_FILE_ID_IS_HERE>/view?usp=sharing')"
read FILE_ID

gdown $FILE_ID

# Begin install of TAK Server

cd
echo "Please type the name of your install file."
echo "Example: takserver-4.8-RELEASE31.noarch.rpm"
read FILE_NAME
sudo yum install $FILE_NAME -y

# Policy install

sudo yum install checkpolicy
cd /opt/tak
sudo ./apply-selinux.sh
sudo semodule -l | grep takserver

# Database install

sudo /opt/tak/db-utils/takserver-setup-db.sh
sudo systemctl daemon-reload

# Start TAK Server Service
sudo systemctl start takserver

# Enable TAK Server auto-start
sudo systemctl enable takserver
