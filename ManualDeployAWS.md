# Manual Deployment GeoCitizen on AWS

1. Create IAM role for EC2 instance for full access to RDS - **geocit-app**:
   1. Add permissions - policy **FullAccessToRDS**
   2. Add some tag

  ![image](https://user-images.githubusercontent.com/71873090/158364501-eb64c365-50fb-45a0-b162-d8aed0eaa461.png)

2. Create EC2 instance with:
   1. AMI - Ubuntu 18.04 LTS - Bionic
   2. Instance Type - t2.micro (- ECUs, 1 vCPUs, 2.5 GHz, -, 1 GiB memory, EBS only)
   3. IAM role - **geocit-app**
   4. Storage - 8 GiB, volume type - **gp2**
   5. Add some tags, for exapmle:
   
   ![image](https://user-images.githubusercontent.com/71873090/158358124-de352a7c-9408-4dd5-8475-7d5e677e4f5c.png)

   6. Configure Security Group
   
    ![image](https://user-images.githubusercontent.com/71873090/158357765-0931da49-d4cf-455d-80c0-fd1728d340b9.png)
    
3. Create RDS instance with:
   1. 
