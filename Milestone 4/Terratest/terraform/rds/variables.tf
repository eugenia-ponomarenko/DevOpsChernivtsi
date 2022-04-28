locals {
  postgres_security_group   = "Postgres SecurityGroup"
}

variable "allocated_storage" {
  type = string
}

variable "engine_name" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "database_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "region" {
  type = string
}