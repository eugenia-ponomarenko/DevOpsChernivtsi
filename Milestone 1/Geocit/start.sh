#!/bin/bash

mvn install
sleep 5
sudo mv target/citizen.war /opt/tomcat/latest/webapps/ 
sleep 5
sudo sh /opt/tomcat/latest/bin/startup.sh
