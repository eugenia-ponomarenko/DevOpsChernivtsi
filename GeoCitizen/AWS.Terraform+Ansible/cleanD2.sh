#!/bin/sh


cd /home/ubuntu/
sudo rm -rf /home/ubuntu/Geocit134
sudo rm -rf Geocit134
git clone https://github.com/mentorchita/Geocit134.git
# https://github.com/eugenia-ponomarenko/DevOpsChernivtsi.git
cd /home/ubuntu/Geocit134

#----------------------------------------------------------------------------------------------------
# Remove old project files from tomcat

sudo rm -rf /usr/share/tomcat/webapps/citizen.war
sudo rm -rf /usr/share/tomcat/webapps/citizen

#----------------------------------------------------------------------------------------------------
# Fix pom.xml

sed -i "s/http:\/\/repo.spring.io/https:\/\/repo.spring.io/g" /home/ubuntu/Geocit134/pom.xml
sed -i "s/>servlet-api</>javax.servlet-api</g" /home/ubuntu/Geocit134/pom.xml
sed -i "s/<distributionManagement>/<\!-- \n <distributionManagement>/g" /home/ubuntu/Geocit134/pom.xml
sed -i "s/<\/distributionManagement>/<\/distributionManagement> \n -->/g" /home/ubuntu/Geocit134/pom.xml

#----------------------------------------------------------------------------------------------------
# Update email credentials

. /home/ubuntu/emailCredentials

old_mail="[a-z0-9.]\{5,\}@gmail\.com"
old_passwd="email.password=[A-Za-z0-9!@#$%^&*-]\{8,32\}"
new_passwd="email.password=$password"

sed -i "s/$old_mail/$email/g" /home/ubuntu/Geocit134/src/main/resources/application.properties
sed -i "s/$old_passwd/$new_passwd/g" /home/ubuntu/Geocit134/src/main/resources/application.properties

#----------------------------------------------------------------------------------------------------
# Update ip addresses

. /home/ubuntu/credentials

old_serverip="[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}"
old_dbip="postgresql:\/\/[a-zA-Z0-9.-]*:5432"
new_dbip="postgresql:\/\/$db_host"

sed -i "s/$old_serverip/$ubuntu_host/g" /home/ubuntu/Geocit134/src/main/java/com/softserveinc/geocitizen/configuration/MongoConfig.java   
sed -i "s/$old_serverip/$ubuntu_host/g" /home/ubuntu/Geocit134/src/main/webapp/static/js/*
sed -i "s/$old_serverip/$ubuntu_host/g" /home/ubuntu/Geocit134/src/main/resources/application.properties
sed -i "s/$old_dbip/$new_dbip/g" /home/ubuntu/Geocit134/src/main/resources/application.properties

# grep -Ril -Eq "$old_serverip" | xargs sudo sed -i "s/$old_serverip/$ubuntu_host/g"
# grep -Ril -Eq "$old_dbip" | xargs sudo sed -i "s/$old_dbip/$new_dbip/g"

#----------------------------------------------------------------------------------------------------
# Correct path to js directory

sed -i "s/\/src\/assets/\.\/static/g" /home/ubuntu/Geocit134/src/main/webapp/index.html

#-----------------------------------------------------------------------------------------------------
# build and deploy

mvn install
sleep 5
sudo mv target/citizen.war /usr/share/tomcat/webapps/ 
sleep 5
sudo sh /usr/share/tomcat/bin/startup.sh