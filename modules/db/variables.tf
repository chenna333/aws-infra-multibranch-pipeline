variable "env" {}
variable "region" { default = "us-east-1" }
variable "subnet_ids" { type = list(string) }
variable "db_name" { type = string }
variable "username" { type = string }
variable "password" { type = string, sensitive = true }
variable "instance_class" { type = string, default = "db.t3.micro" }
variable "allocated_storage" { type = number, default = 20 }
