# file name GeocitDiagram.py
from re import I
from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2
from diagrams.custom import Custom
from diagrams.onprem.iac import Ansible
from diagrams.onprem.iac import Terraform
from diagrams.onprem.ci import Jenkins
from diagrams.onprem.vcs import Github
from diagrams.onprem.client import User, Users
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.network import Tomcat
from diagrams.programming.language import Java



with Diagram(filename="GeoCitizen2", show=False):
    terrraform = Terraform("Terraform")
    jenkins = Jenkins("Jenkins")
    ansible = Ansible("Ansible")
    devops = User('DevOps')
    github = Github('Github')
    playbookAndCreds = Custom("playbook and credentials of Instances", "/home/eugenia/DiagramAsCode/images.png")

    with Cluster('AWS'):
        aws = Custom('', "/home/eugenia/DiagramAsCode/awslogo.png")

        with Cluster('Ubuntu (Application)'):
            ubuntu = EC2("Ubuntu")
            java = Java("")
            repo = Custom("Geocit repository", "/home/eugenia/DiagramAsCode/folder.png")
            maven = Custom("", "/home/eugenia/DiagramAsCode/maven.jpeg")
            tomcat = Tomcat("")
            geoctizen = Custom("Geocitizen", '/home/eugenia/DiagramAsCode/geocit.png')

        with Cluster('CentOS (Database)'):
            centos =  EC2("CentOS")
            postgresql = PostgreSQL("PostgreSQL")

    devops >> jenkins >>  Edge(color="green", label='5') >> playbookAndCreds >>  Edge(color="green", label='5') >> ansible
    devops >>  Edge(label='push') >> github << Edge(color="green", label='clone') << jenkins >> Edge(color="green", label='1') >> terrraform 
    terrraform >> Edge(color="purple", label='2 Connect') >> aws
    aws >> Edge(color="purple", label='3   Create') >> centos
    aws >> Edge(color="purple", label='3   Create') >> ubuntu
    jenkins <<  Edge(color="purple", label='4   Credentials and IP address of Instances') << terrraform
    ubuntu << Edge(color="firebrick", label="6   Configure") << ansible >> Edge(color="firebrick", label="6   Configure") >> centos
    maven >> Edge(label="6.1  Build") >> repo >> Edge(label="6.2  Deploy")>> tomcat >> Edge(reverse=True) >> geoctizen 
    Users("Users") >> Edge(reverse=True) >> tomcat
    geoctizen >> Edge(reverse=True) >> postgresql
    maven >>  Edge(label="Use") >> java