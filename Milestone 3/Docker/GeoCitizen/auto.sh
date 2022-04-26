#!/bin/bash

sudo apt install -y git maven

git clone -b main https://github.com/eugenia-ponomarenko/SSITA-GeoCitizen-AWS.git

# Repair GeoCitizen`s files

email="my.mail0001my@gmail.com"
password="vlsjlvwwocwxqzeb"

sed -i "s/[a-z0-9.]\{5,\}@gmail\.com/$email/g" SSITA-GeoCitizen-AWS/src/main/resources/application.properties
sed -i "s/email.password=[A-Za-z0-9!@#$%^&*-]\{8,32\}/email.password=$password/g" SSITA-GeoCitizen-AWS/src/main/resources/application.properties

docker_ip=$(curl --silent --url "www.ifconfig.me" | tr "\n" " ")
#----------------------------------------------------------------------------------------------------
# Fix application.properties
sed -i -E \
            "s/(http:\/\/localhost:8080)/http:\/\/$docker_ip:80/g; \
            s/(postgresql:\/\/localhost)/postgresql:\/\/$docker_ip/g;
            s/(35.204.28.238)/$docker_ip/g; " SSITA-GeoCitizen-AWS/src/main/resources/application.properties

#----------------------------------------------------------------------------------------------------
# Repair index.html favicon
sed -i "s/\/src\/assets/\.\/static/g" SSITA-GeoCitizen-AWS/src/main/webapp/index.html

#----------------------------------------------------------------------------------------------------
# Repair js bundles
find SSITA-GeoCitizen-AWS/src/main/webapp/static/js/ -type f -exec sed -i "s/localhost:8080/$docker_ip:80/g" {} +
find SSITA-GeoCitizen-AWS/src/main/webapp/static/js/ -type f -exec sed -i "s/localhost/$docker_ip/g" {} +

cd ./SSITA-GeoCitizen-AWS; mvn install