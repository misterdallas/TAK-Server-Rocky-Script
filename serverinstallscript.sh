#!/bin/bash
echo "Running this script will install everything required to get a TAK Server operational within Rocky Linux. Some portions of the install may take a while. Please be patient."
echo "Ensure that you've made the serverinstallscript.sh executable with 'chmod +x serverinstallscript.sh'"
echo "Also, please ensure you run the script from your /root directory"
read -p "Press ENTER to begin."

# Update OS
sudo yum update -y

# Increase system limit for number of concurrent TCP connections
echo -e"* soft nofile 32768\n* hard nofile 32768" |sudo  tee --append /etc/security/limits.conf>/dev/null

# Install EPEL
sudo yum install epel-release -y

# Install Nano
sudo dnf install nano -y

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

# Install Firewalld
sudo yum install firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo systemctl status firewalld

# Configure Firewalld
sudo firewall-cmd --zone=public --add-port 8080/tcp --permanent
sudo firewall-cmd --zone=public --add-port 8088/tcp --permanent
sudo firewall-cmd --zone=public --add-port 8089/tcp --permanent
sudo firewall-cmd --zone=public --add-port 8443/tcp --permanent
sudo firewall-cmd --zone=public --add-port 8444/tcp --permanent
sudo firewall-cmd --zone=public --add-port 8446/tcp --permanent
sudo firewall-cmd --zone=public --add-port 9000/tcp --permanent
sudo firewall-cmd --zone=public --add-port 9001/tcp --permanent
sudo firewall-cmd --reload

echo "********** INSTALLATION COMPLETE! **********"
echo ""
echo "Access your your TAK server via web browser"
echo ""
echo "http://YOURIP:8080 for initial setup"
echo ""
echo "http://YOURIP:8446 unsecure connection"
echo "|"
echo " ---> requires admin account creation"
echo ""
echo "https://YOURIP:8443 secure connection"
echo "|"
echo " ---> requires certificate creation"
