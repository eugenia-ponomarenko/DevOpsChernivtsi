# Manual Deployment GeoCitizen on AWS

## Creating the right infrastructure on AWS

1. First of all, I choose region - **Europe (Frankfurt)**, as use only free tier resources and create RDS instance. RDS instance in free tier is available only in region with t2.micro instances in free tier. 
2. Create IAM role for EC2 instance for full access to RDS - **geocit-app**:
   1. Add permissions - policy **FullAccessToRDS**
   2. Add some tag

  ![image](https://user-images.githubusercontent.com/71873090/158364501-eb64c365-50fb-45a0-b162-d8aed0eaa461.png)

3. Create EC2 instance with:
   1. AMI - Ubuntu 18.04 LTS - Bionic
   2. Instance Type - t2.micro (- ECUs, 1 vCPUs, 2.5 GHz, -, 1 GiB memory, EBS only)
   3. IAM role - **geocit-app**
   4. Storage - 8 GiB, volume type - **gp2**
   5. Add some tags, for exapmle:
   
   ![image](https://user-images.githubusercontent.com/71873090/158358124-de352a7c-9408-4dd5-8475-7d5e677e4f5c.png)

   6. Configure Security Group
   
   ![image](https://user-images.githubusercontent.com/71873090/159156935-b10cae0a-0246-4ee8-936b-db1824f5a465.png)
    
4. Create RDS instance with:
   1. Engine type -  **PostgreSQL**, version - PostgreSQL 12.9-R1 (because 13 version and more aren`t available in free tier)
   2. Templates - **Free Tier**
   3. DB instance identifier - **geocit-db**
   4. Set up credentials
   5. DB instance class - **db.t2.micro**
   6. Disable Storage autoscaling
   7. Database authentication - **Password and IAM database authentication**4
   8. Additional configuration: Initial database name - **ss_demo_1**
   9. Other settings as a default.
5. Configure Security Group for RDS instance. Just open **PostgreSQL port (5432)** in _inbound rules_ for access from EC2 instance.

## EC2 instance configuring
1. Install Java 8

```console
sudo apt-get update
sudo apt-get install openjdk-8-jdk
```

Verify the version of the JDK: 
```console
java -version
```

```
openjdk version "1.8.0_242"
OpenJDK Runtime Environment (build 1.8.0_242-b09)
OpenJDK 64-Bit Server VM (build 25.242-b09, mixed mode)
```

2. Next, install Maven by typing the following command:

```console
sudo apt install maven
```

Verify the installation by running the mvn -version command:
```console
mvn -version
```
The output should look something like this:
```
Apache Maven 3.5.2
Maven home: /usr/share/maven
Java version: 10.0.2, vendor: Oracle Corporation
Java home: /usr/lib/jvm/java-11-openjdk-amd64
Default locale: en_US, platform encoding: ISO-8859-1
OS name: "linux", version: "4.15.0-36-generic", arch: "amd64", family: "unix"
```

3. [Tomcat install](https://linuxize.com/post/how-to-install-tomcat-9-on-ubuntu-18-04/)
