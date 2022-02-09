#!/bin/bash

#---------------
#
sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen.war
sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen


#---------------------------------------------
# Drop and create db
dbuser='postgres'
dbhost='192.168.1.102'
dbport=5432


psql --host=$dbhost --port=$dbport --username=$dbuser -c 'DROP DATABASE ss_demo_1;'
psql --host=$dbhost --port=$dbport --username=$dbuser -c 'CREATE DATABASE ss_demo_1;'


#---------------------------------------------------------------------------------
# fix data

serverip='192.168.1.101'
dbip='192.168.1.102'
email='my.mail0001my@gmail.com'
emailpasswd='devOps1324@'


# Database IP

sed -i "s/postgresql:\/\/localhost/postgresql:\/\/$dbip/g" ~/Geocit134/src/main/resources/application.properties
sed -i "s/35.204.28.238/$dbip/g" ~/Geocit134/src/main/resources/application.properties


# Email update

sed -i "s/ssgeocitizen@gmail.com/$email/g" ~/Geocit134/src/main/resources/application.properties
sed -i "s/=softserve/=$emailpasswd/g" ~/Geocit134/src/main/resources/application.properties

# Server IP

sed -i "s/http:\/\/localhost/http:\/\/$serverip/g" ~/Geocit134/src/main/resources/application.properties

sed -i "s/\/src\/assets/\.\/static/g" ~/Geocit134/src/main/webapp/index.html

sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/java/com/softserveinc/geocitizen/configuration/MongoConfig.java
sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js
sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js.map
sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js
sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js.map


#-------------------------------------------------------------------------------------
# build and deploy

mvn install
sleep 5
sudo mv target/citizen.war /opt/tomcat/latest/webapps/ 
sleep 5
sudo sh /opt/tomcat/latest/bin/startup.sh


# Catalina Logs
# sudo tail -f /opt/tomcat/latest/logs/catalina.out