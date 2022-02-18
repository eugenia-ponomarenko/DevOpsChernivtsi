#!/bin/bash

# Remove old project files from tomcat
sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen.war
sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen

#----------------------------------------------------------------------------------------------------
# Update email credentials
# email='example@gmail.com'
# emailpasswd='passwd'

# sed -i "s/ssgeocitizen@gmail.com/$email/g" ~/Geocit134/src/main/resources/application.properties
# sed -i "s/=softserve/=$emailpasswd/g" ~/Geocit134/src/main/resources/application.properties

#----------------------------------------------------------------------------------------------------
# Change old IP addresses to new ones
# serverip='172.31.18.225'
# dbip='geocit-db.cstswihxzihx.eu-central-1.rds.amazonaws.com'

# sed -i "s/http:\/\/192.168.65.101/http:\/\/$serverip/g" ~/Geocit134/src/main/resources/application.properties
# sed -i "s/postgresql:\/\/192.168.65.102/postgresql:\/\/$dbip/g" ~/Geocit134/src/main/resources/application.properties

# # Correct path to js folder
# sed -i "s/\/src\/assets/\.\/static/g" ~/Geocit134/src/main/webapp/index.html

# sed -i "s/192.168.65.101/$serverip/g" ~/Geocit134/src/main/java/com/softserveinc/geocitizen/configuration/MongoConfig.java   
# sed -i "s/192.168.65.101/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js
# sed -i "s/192.168.65.101/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js.map
# sed -i "s/192.168.65.101/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js
# sed -i "s/192.168.65.101/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js.map


old_serverip="18.159.149.79"
new_serverip="3.70.135.117"

old_dbip="192.168.65.102"
new_dbip="geocit-db.cstswihxzihx.eu-central-1.rds.amazonaws.com"

grep -Ril "$old_serverip" | xargs sudo sed -i "s/$old_serverip/$new_serverip/g"
grep -Ril "$old_dbip" | xargs sudo sed -i "s/$old_dbip/$new_dbip/g"
sed -i "s/http:\/\/$old_serverip/http:\/\/$new_serverip/g" ~/Geocit134/src/main/resources/application.properties

#-----------------------------------------------------------------------------------------------------
# build and deploy

mvn install
sleep 5
sudo mv target/citizen.war /opt/tomcat/latest/webapps/ 
sleep 5
sudo sh /opt/tomcat/latest/bin/startup.sh
