#!/bin/bash

#GeoCitzen
git clone https://github.com/eugenia-ponomarenko/GeoCitizen.git

######## Repair files in project ######

#----------------------------------------------------------------------------------------------------
# Change email creds
email="example@gmail.com" 
password="passwd"
server_ip="$(curl ifconfig.me)"

sed -i "s/[a-z0-9.]\{5,\}@gmail\.com/$email/g" GeoCitizen/src/main/resources/application.properties
sed -i "s/email.password=[A-Za-z0-9!@#$%^&*-]\{8,32\}/email.password=$password/g" GeoCitizen/src/main/resources/application.properties

#----------------------------------------------------------------------------------------------------
# Fix application.properties
sed -i -E \
            "s/(http:\/\/localhost)/http:\/\/$server_ip/g; \
            s/(postgresql:\/\/localhost)/postgresql:\/\/$server_ip/g;
            s/(35.204.28.238)/$server_ip/g; " GeoCitizen/src/main/resources/application.properties

#----------------------------------------------------------------------------------------------------
# Repair index.html favicon
sed -i "s/\/src\/assets/\.\/static/g" GeoCitizen/src/main/webapp/index.html

#----------------------------------------------------------------------------------------------------
# Repair js bundles
find GeoCitizen/src/main/webapp/static/js/ -type f -exec sed -i "s/localhost/$server_ip/g" {} +

#----------------------------------------------------------------------------------------------------
# Build citizen.war
cd GeoCitizen/; mvn install
