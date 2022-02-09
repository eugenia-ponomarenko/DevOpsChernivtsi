# Geo Citizen


### tools&technologies


- [Git 2](https://linuxize.com/post/how-to-install-git-on-ubuntu-18-04/)
- [PostgreSQL](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-centos-7) 
- [Tomcat 9](https://linuxize.com/post/how-to-install-tomcat-9-on-ubuntu-18-04/)
- [Maven 3.6.3](https://linuxize.com/post/how-to-install-apache-maven-on-ubuntu-18-04/)
- [Ubuntu 18.04](https://codebots.com/docs/ubuntu-18-04-virtual-machine-setup)
- [CentOS 7.9](https://linuxhint.com/install-centos-7-virtualbox/)


## Setting ip addresses

### Define Host Only Ethernet Adapter in Virtual Box on my laptop

 In the VirtualBox client, open menu option File | Host Network Manager. Create a new Virtual Box Host Only Ethernet Adapter (in my case #2). Set an IP address in the range in which you want to assign an IP address to your VM. I have set 192.168.1.100 and I will assign the IP address 192.168.1.101 to the Ubuntu VM and 192.168.1.102 CentOs VM. Do not define a DHCP Server on the second tab.
 
### Enable a network adapter for the specific VM of type Virtual Box Host Only Ethernet Adapter  

Select the VM in the Virtual Box client – before it is started. Press Settings. Click on Network. Open one of the currently unconfigured Adapter tabs. Select the Host Only Ethernet Adapter that was created in the previous step, #2 for me. Check Enable the Network Adapter. Make sure that Promiscuous Mode allows VMs and the checkbox Cable Connected is checked.

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


## Build and deploy

1. Clone a repository `git clone https://github.com/mentorchita/Geocit134.git; cd Geocit134`
2. In **pom.xml** make changes:

    - add javax in <artifacrId>
    
    ```
    <!--Servlet API-->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <version>${servlet-api.version}</version>
            <scope>provided</scope>
        </dependency>
    ```
    
    - Update the repository url to use HTTPS. Something like this:

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

    - comment **DistributionManagement**

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
  
  3. Write __db.sh__ script for cleanig and creating database:
  
  ```
  #!bin/bash

  dbuser='postgres'
  dbhost='192.168.1.102'
  dbport=5432
 
  psql --host=$dbhost --port=$dbport --username=$dbuser -c 'DROP DATABASE ss_demo_1;'
  psql --host=$dbhost --port=$dbport --username=$dbuser -c 'CREATE DATABASE ss_demo_1;'
  ```
  
  4. Write __fix.sh__ to upload all 'localhost' to new ip address 
  
  ```
  #!/bin/bash

  # Remove old project files from tomcat
  sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen.war
  sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen

  #----------------------------------------------------------------------------------------------------
  # Update email credentials
  email='my.mail0001my@gmail.com'
  emailpasswd='devOps1324@'

  sed -i "s/ssgeocitizen@gmail.com/$email/g" ~/Geocit134/src/main/resources/application.properties
  sed -i "s/=softserve/=$emailpasswd/g" ~/Geocit134/src/main/resources/application.properties

  #----------------------------------------------------------------------------------------------------
  # Change localhost to 192.168.1.101

  sed -i "s/\/src\/assets/\.\/static/g" ~/Geocit134/src/main/webapp/index.html

  sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js
  sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js.map
  sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js
  sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js.map
  ```
  
  5. And write script for build and deploy project __start.sh__
  
  ```
  #!/bin/bash

  mvn install
  sleep 5
  sudo mv target/citizen.war /opt/tomcat/latest/webapps/ 
  sleep 5
  sudo sh /opt/tomcat/latest/bin/startup.sh
  ```
  
  6. Then open http://192.168.1.101:8080/citizen/
