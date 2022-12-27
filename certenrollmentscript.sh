#!/bin/bash
echo "********** PLEASE ADVISE **********"
echo ""
echo "YOU NEED TO EDIT THE cert-metadata.sh FILE LOCATED IN /opt/tak/certs BEFORE RUNNING THIS SCRIPT"
echo "example:"
echo "COUNTRY=US"
echo "STATE=FL"
echo "CITY=MI"
echo "ORGANIZATION=TC"
echo "ORGANIZATIONAL_UNIT=TAK"
echo ""
echo "********** PLEASE ADVISE **********"
echo ""
echo ""
echo "Running this script will enable certificate enrollment for your TAK Server. Please follow the prompts when necessary."
read -p "Press ENTER to begin."

# Move to cert directory and login as tak user
cd /opt/tak/certs
sudo su tak

# Make Root Certificate Authority
./makeRootCA.sh

# Make Intermediate Certificate
./makeCert.sh ca

# Make Server Certificate 
./makeCert.sh server takserver

# Make Client Certificate
./makeCert.sh client Admin

# Make User Certificate
./makeCert.sh client takuser

# Exit tak user
exit

# Move folders and give Admin.pem Admin rights
cd /opt/tak/utils
sudo java -jar UserManager.jar certmod -A /opt/tak/certs/files/Admin.pem

# Restart TAK Server service
sudo service takserver restart
