# Geo Citizen

### tools&technologies
- [Git 2](https://linuxize.com/post/how-to-install-git-on-ubuntu-18-04/)
- [PostgreSQL](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-centos-7) 
- [Tomcat 9](https://linuxize.com/post/how-to-install-tomcat-9-on-ubuntu-18-04/)
- [Maven 3.6.3](https://linuxize.com/post/how-to-install-apache-maven-on-ubuntu-18-04/)
- [Ubuntu 18.04](https://codebots.com/docs/ubuntu-18-04-virtual-machine-setup)
- [CentOS 7.9](https://linuxhint.com/install-centos-7-virtualbox/)

## Build and deploy

1. Clone a repository `git clone https://github.com/mentorchita/Geocit134.git; cd Geocit134`
2. In **pom.xml** make changes:

    - add javax in <artifacrId>
    
    ```
    <!--Servlet API-->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <version>${servlet-api.version}</version>
            <scope>provided</scope>
        </dependency>
    ```
    
    - Update the repository url to use HTTPS. Something like this:

    ```
        <repository>
            <id>org.springframework.maven.milestone</id>
            <name>Spring Maven Milestone Repository</name>
            <url>https://repo.spring.io/milestone</url>
        </repository>
    ```
    
    ```
        <repository>
            <id>spring-milestone</id>
            <name>Spring Maven MILESTONE Repository</name>
            <url>https://repo.spring.io/libs-milestone</url>
        </repository>
    ```

    - comment **DistributionManagement**

    ```
        <distributionManagement>
          <repository>
            <id>nexus</id>
            <name>Releases</name>
            <url>http://35.188.29.52:8081/repository/maven-releases</url>
          </repository>
          <snapshotRepository>
            <id>nexus</id>
            <name>Snapshot</name>
            <url>http://35.188.29.52:8081/repository/maven-snapshots</url>
          </snapshotRepository>
        </distributionManagement>
    ```
  
  3. Write __db.sh__ script for cleanig and creating database:
  
  ```
  #!bin/bash

  dbuser='postgres'
  dbhost='192.168.1.102'
  dbport=5432
 
  psql --host=$dbhost --port=$dbport --username=$dbuser -c 'DROP DATABASE ss_demo_1;'
  psql --host=$dbhost --port=$dbport --username=$dbuser -c 'CREATE DATABASE ss_demo_1;'
  ```
  
  4. Write __fix.sh__ to upload all 'localhost' to new ip address 
  
  ```
  #!/bin/bash

  # Remove old project files from tomcat
  sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen.war
  sudo rm -rf /opt/tomcat/apache-tomcat-9.0.58/webapps/citizen

  #----------------------------------------------------------------------------------------------------
  # Update email credentials
  email='my.mail0001my@gmail.com'
  emailpasswd='devOps1324@'

  sed -i "s/ssgeocitizen@gmail.com/$email/g" ~/Geocit134/src/main/resources/application.properties
  sed -i "s/=softserve/=$emailpasswd/g" ~/Geocit134/src/main/resources/application.properties

  #----------------------------------------------------------------------------------------------------
  # Change localhost to 192.168.1.101

  sed -i "s/\/src\/assets/\.\/static/g" ~/Geocit134/src/main/webapp/index.html

  sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js
  sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/app.6313e3379203ca68a255.js.map
  sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js
  sed -i "s/localhost/$serverip/g" ~/Geocit134/src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js.map
  ```
  
  5. And write script for build and deploy project __start.sh__
  
  ```
  #!/bin/bash

  mvn install
  sleep 5
  sudo mv target/citizen.war /opt/tomcat/latest/webapps/ 
  sleep 5
  sudo sh /opt/tomcat/latest/bin/startup.sh
  ```
  
  6. Then open http://192.168.1.101:8080/citizen/
