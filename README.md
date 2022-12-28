# TAK-Server-Rocky-Script

This script will get a basic TAK Server installed on Rocky 8 in about 15 minutes. This method utilizes Gdown in order to install the takserver-4.8-RELEASE31.noarch.rpm

## ****** BEFORE RUNNING THE SCRIPT *****

### Get the repo on your VPS w/ git
```
sudo dnf install git -y
git clone https://github.com/misterdallas/TAK-Server-Rocky-Script.git
```
### Make the script executable
```
cd /TAK-Server-Rocky-Script
chmod +x serverinstallscript.sh
```
## ***** EXECUTE THE SCRIPT *****

### Return back to the /root directory and run the script
```
cd
./TAK-Server-Rocky-Script/serverinstallscript.sh
```
