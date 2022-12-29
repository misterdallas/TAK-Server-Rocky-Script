# Running this guide will enable certificate enrollment for your TAK Server. Please follow the prompts when necessary.

## YOU NEED TO EDIT THE cert-metadata.sh FILE LOCATED IN /opt/tak/certs BEFORE FOLLOWING THIS GUIDE.

**Example:**  
COUNTRY=**US** *(2 letters)*  
STATE=**FL** *(2 letters)*  
CITY=**MI** *(2 letters)*  
ORGANIZATION=**TC** *(Whatever you want)*  
ORGANIZATIONAL_UNIT=**TAK** *(Whatever you want)*  

#### Move to cert directory and login as tak user
```
cd /opt/tak/certs
sudo su tak
```

#### Make Root Certificate Authority -- **Name RootCa something unique**
```
./makeRootCa.sh
```

#### Make Intermediate Certificate -- **intermediate-"NAME"** This is your intermediate cert you issue out for Certificate Enrollment
```
./makeCert.sh ca
```

#### Make Server Certificate -- **"takserver"** can be changed; however, it's not advisable
```
./makeCert.sh server takserver
```

#### Make Client Certificate
```
./makeCert.sh client Admin
```

#### Make User Certificate
```
./makeCert.sh client takuser
```

#### Exit tak user
```
exit
```

#### Move folders and give Admin.pem Admin rights
```
cd /opt/tak/utils
sudo java -jar UserManager.jar certmod -A /opt/tak/certs/files/Admin.pem
```

#### Restart TAK Server service
```
sudo service takserver restart
```
