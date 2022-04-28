terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = var.region
}


resource "aws_db_instance" "GeoCitDB" {
  allocated_storage      = var.allocated_storage
  engine                 = var.engine_name
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.database_name
  username               = var.username
  password               = var.password
  parameter_group_name   = "default.postgres12"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.RDS_SecurityGroup.id]
}