```
#!/bin/bash

# Remove old project files from tomcat
sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen.war
sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen

#-------------------------------------------------------------------------------------------$
# Update email credentials
# email='example@gmail.com'
# emailpasswd='passwd'

# sed -i "s/ssgeocitizen@gmail.com/$email/g" ~/Geocit134/src/main/resources/application.prop$
# sed -i "s/=softserve/=$emailpasswd/g" ~/Geocit134/src/main/resources/application.properties

#-------------------------------------------------------------------------------------------$
# Change old IP addresses to new ones
new_serverip=""
old_serverip="18.159.48.44"

old_dbip="postgresql-12.cstswihxzihx.eu-central-1.rds.amazonaws.com"
new_dbip="postgresql-12.cstswihxzihx.eu-central-1.rds.amazonaws.com"

grep -Ril "$old_serverip" | xargs sudo sed -i "s/$old_serverip/$new_serverip/g"
grep -Ril "$old_dbip" | xargs sudo sed -i "s/$old_dbip/$new_dbip/g"


# Correct path to js folder
sed -i "s/\/src\/assets/\.\/static/g" ~/DevOpsChernivtsi/Geocit/Geocit134/src/main/webapp/in$


#-------------------------------------------------------------------------------------------$
# bbb and deploy

mvn install
sleep 5
sudo mv target/citizen.war /opt/tomcat/latest/webapps/
sleep 5
sudo sh /opt/tomcat/latest/bin/startup.sh
```
