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
# Change localhost to 192.168.1.101
serverip = 192.168.65.101
dbip = 192.168.65.102

sed -i "s/http:\/\/localhost/http:\/\/$serverip/g" ~/Geocit134/src/main/resources/application.properties
sed -i "s/postgresql:\/\/localhost/postgresql:\/\/$dbip/g" ~/Geocit134/src/main/resources/application.properties
sed -i "s/postgresql:\/\/35.204.28.238/postgresql:\/\/$dbip/g" ~/Geocit134/src/main/resources/application.properties

# Correct path to js folder
sed -i "s/\/src\/assets/\.\/static/g" ~/Geocit134/src/main/webapp/index.html

sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/java/com/softserveinc/geocitizen/configuration/MongoConfig.java   
sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js
sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js.map
sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js
sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js.map
