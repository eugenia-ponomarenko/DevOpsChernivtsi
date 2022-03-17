#!/bin/sh

# cd ~/
# git clone https://github.com/mentorchita/Geocit134.git
cd ~/Geocit134

#----------------------------------------------------------------------------------------------------
# # Remove old project files from tomcat

# sudo rm -rf /usr/share/tomcat/webapps/citizen.war
# sudo rm -rf /usr/share/tomcat/webapps/citizen

#----------------------------------------------------------------------------------------------------
# Fix pom.xml

sed -i "s/http:\/\/repo.spring.io/https:\/\/repo.spring.io/g" ~/Geocit134/pom.xml
sed -i "s/>servlet-api</>javax.servlet-api</g" ~/Geocit134/pom.xml

#----------------------------------------------------------------------------------------------------
# Update email credentials

. ~/emailCredentials

sed -i "s/ssgeocitizen@gmail.com/$email/g" ~/Geocit134/src/main/resources/application.properties
sed -i "s/=softserve/=$password/g" ~/Geocit134/src/main/resources/application.properties

#----------------------------------------------------------------------------------------------------
# Update ip addresses

. ~/credentials

old_serverip="[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}"
old_dbip="postgresql:\/\/[a-zA-Z0-9.-]*:5432"
new_dbip="postgresql:\/\/$db_host"

sed -i "s/$old_serverip/$ubuntu_host/g" ~/Geocit134/src/main/java/com/softserveinc/geocitizen/configuration/MongoConfig.java   
sed -i "s/$old_serverip/$ubuntu_host/g" ~/Geocit134/src/main/webapp/static/js/*
sed -i "s/$old_serverip/$ubuntu_host/g" ~/Geocit134/src/main/resources/application.properties
sed -i "s/$old_dbip/$new_dbip/g" ~/Geocit134/src/main/resources/application.properties

# grep -Ril -Eq "$old_serverip" | xargs sudo sed -i "s/$old_serverip/$ubuntu_host/g"
# grep -Ril -Eq "$old_dbip" | xargs sudo sed -i "s/$old_dbip/$new_dbip/g"

#----------------------------------------------------------------------------------------------------
# Correct path to js directory

sed -i "s/\/src\/assets/\.\/static/g" ~/Geocit134/src/main/webapp/index.html

#-----------------------------------------------------------------------------------------------------
# build and deploy

mvn install
sleep 1
sudo mv target/citizen.war /usr/share/tomcat/webapps/ 
sleep 1
sudo sh /usr/share/tomcat/bin/startup.sh