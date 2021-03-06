locals {
  key_name                  = "geocit-app"
  ami_id                    = "ami-042ad9eec03638628"  # Ubuntu Server 18.04 LTS (HVM)
  instance_type             = "t2.micro"
  vm_name                   = "Ubuntu WebServer"
  webserver_security_group  = "Ubuntu SecurityGroup"
  iam_role_name             = "AccessRDS"
  iam_policy_att_name       = "policy_attach"
  policy_arn                = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  iam_instance_profile_name = "GCprofile"
}

variable "ec2_ports" {
  type    = list(number)
  default = [22, 8080, 587]
}

variable "region" {
  type = string
}

variable "instance_type" {
  type = string
}