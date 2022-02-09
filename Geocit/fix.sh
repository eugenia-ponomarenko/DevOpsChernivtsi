#!/bin/bash


sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen.war
sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen

echo "It works"

serverip='192.168.1.101'
email='my.mail0001my@gmail.com'
emailpasswd='devOps1324@'

sed -i "s/ssgeocitizen@gmail.com/$email/g" ~/Geocit134/src/main/resources/application.properties
sed -i "s/=softserve/=$emailpasswd/g" ~/Geocit134/src/main/resources/application.properties


sed -i "s/\/src\/assets/\.\/static/g" ~/Geocit134/src/main/webapp/index.html

sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js
sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js.map
sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js
sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js.map


# sudo tail -f /opt/tomcat/latest/logs/catalina.out