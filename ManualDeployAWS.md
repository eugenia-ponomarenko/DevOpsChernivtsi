# Manual Deployment GeoCitizen on AWS

## Creating the right infrastructure on AWS

1. First of all, I choose region - **Europe (Frankfurt)**, as use only free tier resources and create RDS instance. RDS instance in free tier is available only in region with t2.micro instances in free tier. 
2. Create IAM role for EC2 instance for full access to RDS - **geocit-app**:
   1. Add permissions - policy **FullAccessToRDS**
   2. Add some tag

  ![image](https://user-images.githubusercontent.com/71873090/158364501-eb64c365-50fb-45a0-b162-d8aed0eaa461.png)

3. Create EC2 instance with:
   1. AMI - Ubuntu 18.04 LTS - Bionic
   2. Instance Type - t2.micro (- ECUs, 1 vCPUs, 2.5 GHz, -, 1 GiB memory, EBS only)
   3. IAM role - **geocit-app**
   4. Storage - 8 GiB, volume type - **gp2**
   5. Add some tags, for exapmle:
   
   ![image](https://user-images.githubusercontent.com/71873090/158358124-de352a7c-9408-4dd5-8475-7d5e677e4f5c.png)

   6. Configure Security Group
> port 8080 - for Tomcat
> 
> port 22 - SSH
> 
> port 587 - SMTP for GMAIL
   
  ![image](https://user-images.githubusercontent.com/71873090/159160959-24765c9d-07f7-4020-a569-bb6e6ca8ba16.png)

**Important**
> I used port 587  because it is now preferred over port 25 in mail, because it's this authentication mechanism that prevents the propagation of spam and malware submissions. 
    
4. Create RDS instance with:
   1. Engine type -  **PostgreSQL**, version - PostgreSQL 12.9-R1 (because 13 version and more aren`t available in free tier)
   2. Templates - **Free Tier**
   3. DB instance identifier - **geocit-db**
   4. Set up credentials
   5. DB instance class - **db.t2.micro**
   6. Disable Storage autoscaling
   7. Database authentication - **Password and IAM database authentication**4
   8. Additional configuration: Initial database name - **ss_demo_1**
   9. Other settings as a default.
5. Configure Security Group for RDS instance. Just open **PostgreSQL port (5432)** in _inbound rules_ for access from EC2 instance.

## EC2 instance configuring
1. Install Java 8

```console
sudo apt-get update
sudo apt-get install openjdk-8-jdk
```

Verify the version of the JDK: 
```console
java -version
```

```
openjdk version "1.8.0_242"
OpenJDK Runtime Environment (build 1.8.0_242-b09)
OpenJDK 64-Bit Server VM (build 25.242-b09, mixed mode)
```

2. Next, install Maven by typing the following command:

```console
sudo apt install maven
```

Verify the installation by running the mvn -version command:
```console
mvn -version
```
The output should look something like this:
```
Apache Maven 3.5.2
Maven home: /usr/share/maven
Java version: 10.0.2, vendor: Oracle Corporation
Java home: /usr/lib/jvm/java-11-openjdk-amd64
Default locale: en_US, platform encoding: ISO-8859-1
OS name: "linux", version: "4.15.0-36-generic", arch: "amd64", family: "unix"
```

3. [Tomcat install](https://linuxize.com/post/how-to-install-tomcat-9-on-ubuntu-18-04/)

## Build and deploy

1. Clone a repository `git clone https://github.com/mentorchita/Geocit134.git; cd Geocit134`
2. Create bash script to fix pom.xml, update ip addresses and deploy GeoCitizen on Tomcat:

```bash
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

# Correct path to js folder
sed -i "s/\/src\/assets/\.\/static/g" ~/Geocit134/src/main/webapp/index.html

old_serverip="18.159.149.79"
new_serverip="3.70.135.117"

old_dbip="192.168.65.102"
new_dbip="geocit-db.cstswihxzihx.eu-central-1.rds.amazonaws.com"

grep -Ril "$old_serverip" | xargs sudo sed -i "s/$old_serverip/$new_serverip/g"
grep -Ril "$old_dbip" | xargs sudo sed -i "s/$old_dbip/$new_dbip/g"

#-----------------------------------------------------------------------------------------------------
# build and deploy

mvn install
sleep 5
sudo mv target/citizen.war /opt/tomcat/latest/webapps/ 
sleep 5
sudo sh /opt/tomcat/latest/bin/startup.sh

```
