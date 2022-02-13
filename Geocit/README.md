# Manual deploy GeoCitizen


### tools&technologies

- [Ubuntu Server 18.04](https://losst.ru/ustanovka-ubuntu-server-18-04)
- [CentOS 7.9](https://linuxhint.com/install-centos-7-virtualbox/)
- [Java 8](https://tecadmin.net/install-oracle-java-8-ubuntu-via-ppa/)
- [Tomcat 9](https://linuxize.com/post/how-to-install-tomcat-9-on-ubuntu-18-04/)
- [Maven 3.6.3](https://linuxize.com/post/how-to-install-apache-maven-on-ubuntu-18-04/)
- [Git 2](https://linuxize.com/post/how-to-install-git-on-ubuntu-18-04/)
- [PostgreSQL](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-centos-7) 


## Setting ip addresses

### Define Host Only Ethernet Adapter in Virtual Box on my laptop

 In the VirtualBox client, open menu option File | Host Network Manager. Create a new Virtual Box Host Only Ethernet Adapter (in my case #2). Set an IP address in the range in which you want to assign an IP address to your VM. I have set 192.168.1.100 and I will assign the IP address 192.168.1.101 to the Ubuntu VM and 192.168.1.102 CentOs VM. Do not define a DHCP Server on the second tab.

  ![image](https://user-images.githubusercontent.com/71873090/153762323-744f571c-15d8-493f-8e3d-264929af0cf5.png)

 
### Enable a network adapter for the specific VM of type Virtual Box Host Only Ethernet Adapter  

Select the VM in the Virtual Box client – before it is started. Press Settings. Click on Network. Open one of the currently unconfigured Adapter tabs. Select the Host Only Ethernet Adapter that was created in the previous step, #3 for me. Check Enable the Network Adapter. Make sure that Promiscuous Mode allows VMs and the checkbox Cable Connected is checked.

#### Ubuntu 

Configure as a static assignment to the network interface on Ubuntu. To configure system to use a static IP address assignment, add the static method to the inet address family statement for the appropriate interface in the file /etc/network/interfaces. `nano /etc/network/interfaces`

Edit the file, adding the following section:

```
# My static IP configuration for the VirtualBox Host Only Adapter
auto enp0s8
iface enp0s8 inet static
address 192.168.1.101
netmask 255.255.255.0
```

Save the file and restart Network Interface

`$ sudo systemctl restart network`

After that the configuration of network interface enp0s8 will already be active.

#### CentOS

Configure as a static assignment to the network interface on CentOS. To configure system to use a static IP address assignment, add the static method to the BOOTPROTO for the appropriate interface in the created file /etc/sysconfig/network-scripts. 

```$ sudo nano /etc/sysconfig/network-scripts```

```
DEVICE="enp0s8"
ONBOOT=yes
NETBOOT=yes
IPADDR=192.168.1.102
GATEWAY=192.168.1.100
TYPE=Ethernet
NERMASJ=255.255.255.0
BOOTPROTO=static
DEFROUTE=yes
```

Save the file and restart Network Interface

`$ sudo systemctl restart network`

Now when Network Interface is restarted, the configuration of network interface enp0s8 will already be active.

### Ping the VM from the laptop

Finally, I establish if the VM is indeed accessible from the host. I open a command line window on the host and use ping to verify the connection:

![image](https://user-images.githubusercontent.com/71873090/153146381-d126d64a-a6fc-49f1-94a6-0419e01a722d.png)


## Setting up and accessing the Postgresql database

### Basic Setup

1. Switch to the PostgreSQL 
```
$ sudo su - postgres
$ psql
```

2. Add new password to **postgres** user
```# ALTER USER postgres WITH PASSWORD 'postgres';```

3. Create **ss_demo_1** db to a specific postgres user
```# createdb ss_demo_1 -O postgres```

### Access to db from Ubuntu VM

1.  Edit **pg_hba.conf**
``` $ sudo nano /var/lib/pgsql/data/pg_hba.conf```

In IPv4 local connection change localhost to Ubuntu static IP address 192.168.1.101/24 and change method to **md5**

![image](https://user-images.githubusercontent.com/71873090/153160998-5f3f0a55-3ff0-4b8e-9472-946778c55425.png)

2. Then edit **postgresql.conf**
``` $ sudo nano /var/lib/pgsql/data/postgresql.conf ```

In listen_addresses change localhost to *.

![image](https://user-images.githubusercontent.com/71873090/153161639-af45318b-b160-4892-a34e-5851e679b02f.png)

3. After that restart PostgreSQL service for changes to take effect.


```$ sudo systemctl restart postgresql```

4. Add rules to firewall for PostgreSQL service in order for Ubuntu to connect to the database server and restart PostgreSQL to make changes work.

  ```
  $ sudo firewall-cmd --add-service=postgresql
  $ sudo firewall-cmd --add-service=postgresql --permanent
  $ sudo systemctl restart postgres
  ```

## Build and deploy

1. Clone a repository `git clone https://github.com/mentorchita/Geocit134.git; cd Geocit134`

2. I tried to execute `mvn install`, but received a BUILD FAILURE error:

 
 ![image](https://user-images.githubusercontent.com/71873090/153762424-20d23e6f-8278-4f77-b5b3-10f8060bacbe.png)

As you can see here there was a problem with obtaining dependencies. 

3. In **pom.xml** make changes:
    
    - Update the repository url to use HTTPS. Because as of January 15, 2020, the central repository no longer supports over HTTP and requires that requests to the repository be transmitted over HTTPS. As you can see below:

    ```
        <repository>
            <id>org.springframework.maven.milestone</id>
            <name>Spring Maven Milestone Repository</name>
            <url>https://repo.spring.io/milestone</url>
        </repository>
    ```
    
    ```
        <repository>
            <id>spring-milestone</id>
            <name>Spring Maven MILESTONE Repository</name>
            <url>https://repo.spring.io/libs-milestone</url>
        </repository>
    ```

    - then comment **DistributionManagement**, because I don`t use it

    ```
        <distributionManagement>
          <repository>
            <id>nexus</id>
            <name>Releases</name>
            <url>http://35.188.29.52:8081/repository/maven-releases</url>
          </repository>
          <snapshotRepository>
            <id>nexus</id>
            <name>Snapshot</name>
            <url>http://35.188.29.52:8081/repository/maven-snapshots</url>
          </snapshotRepository>
        </distributionManagement>
    ```
    
  3. Also, I used the grep command to find **localhost** in all files in "Geocit134" directory:
   
   `grep -Ril "localhost" ./`
   
   And received such a conclusion:
   
   ```
   ./src/main/webapp/static/js/app.6313e3379203ca68a255.js.map                                             
   ./src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js                                              
   ./src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js.map                                          
   ./src/main/webapp/static/js/app.6313e3379203ca68a255.js                                                 
   ./src/main/resources/application.properties                                                             
   ./src/main/java/com/softserveinc/geocitizen/configuration/MongoConfig.java                              
   ./README.md
   ./front-end/src/components/map/main.js                                                                  
   ./front-end/src/main.js                                                                                 
   ./front-end/test/e2e/nightwatch.conf.js                                                                 
   ./front-end/test/e2e/specs/test.js                                                                      
   ./front-end/README.md                                                                                   
   ./front-end/config/index.js
   ```
  
  So in step 6, I edited all the files from the src directory.
  
  5. Then, I found an unknown address in **application.properties** - 35.204.28.238, as you can see in below: 
  
  ```
  #liquibase
  driver=org.postgresql.Driver
  url=jdbc:postgresql://35.204.28.238:5432/ss_demo_1
  username=postgres
  password=postgres
  changeLogFile=src/main/resources/liquibase/mainChangeLog.xml
  verbose=true
  dropFirst=false
  outputChangeLogFile=src/main/resources/liquibase/changeLog-NEW.postgresql.sql
  referenceUrl=jdbc:postgresql://35.204.28.238:5432/ss_demo_1_test
  diffChangeLogFile=src/main/resources/liquibase/diffChangeLog.yaml
  referenceUsername=${db.username}
  referencePassword=${db.password}
  spring.liquibase.change-log=src/main/resources/liquibase/structure.yaml
  ```
  
  So I decided to change it to a new IP address of the database so that liquibase could access the new database. I did it in the next step.

  6. Write __fix.sh__ to change old IP addresses or localhost`s in Geocit134/src directory to new ones and update email credentials: 
  
  ```
  #!/bin/bash

  # Remove old project files from tomcat
  sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen.war
  sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen

  #----------------------------------------------------------------------------------------------------
  # Update email credentials
  email='example@gmail.com'
  emailpasswd='passwd'

  sed -i "s/ssgeocitizen@gmail.com/$email/g" ~/Geocit134/src/main/resources/application.properties
  sed -i "s/=softserve/=$emailpasswd/g" ~/Geocit134/src/main/resources/application.properties

  #----------------------------------------------------------------------------------------------------
  # Change old IP addresses to new ones
  serverip = 192.168.65.101
  dbip = 192.168.65.102
  
  sed -i "s/http:\/\/localhost/http:\/\/$serverip/g" ~/Geocit134/src/main/resources/application.properties
  sed -i "s/postgresql:\/\/localhost/postgresql:\/\/$dbip/g" ~/Geocit134/src/main/resources/application.properties
  sed -i "s/postgresql:\/\/35.204.28.238/postgresql:\/\/$dbip/g" ~/Geocit134/src/main/resources/application.properties
  
  # Correct path to js folder
  sed -i "s/\/src\/assets/\.\/static/g" ~/Geocit134/src/main/webapp/index.html
  
  # Change localhost to database ip
  sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/java/com/softserveinc/geocitizen/configuration/MongoConfig.java   
  
   # Change localhost to server ip
  sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js
  sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js.map
  sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js
  sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js.map
  ```
  
  7. And write script for build and deploy project __start.sh__
  
  ```
  #!/bin/bash

  mvn install
  sleep 1
  sudo mv target/citizen.war /opt/tomcat/latest/webapps/ 
  sleep 1
  sudo sh /opt/tomcat/latest/bin/startup.sh
  ```
  
  8. Write __db.sh__ script for cleanig and creating database:
  
  ```
  #!bin/bash

  dbuser='postgres'
  dbhost='192.168.1.102'
  dbport=5432
 
  psql --host=$dbhost --port=$dbport --username=$dbuser -c 'DROP DATABASE ss_demo_1;'
  psql --host=$dbhost --port=$dbport --username=$dbuser -c 'CREATE DATABASE ss_demo_1;'
  ```
  
  9. Then open http://192.168.1.101:8080/citizen/
