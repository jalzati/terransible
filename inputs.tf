variable "region" {
  description = "Region where the infrastructure will be created"
}

data "aws_availability_zones" "available_azs" {}

variable "owner" {
  description = "Value of the Owner tag"
}

variable "department" {
  description = "Value of the Department tag (i.e.: DevOps)"
  default = "DevOps"
}

variable "environment" {
  description = "Value of the Environment tag (i.e.: research)"
  default = "research"
}

variable "vpc_cidr" {
  description = "CIDR assigned to the VPC"
}

variable "subnet_cidrs"{
  description = "CIDRs assigned to the public and private subnets"
  type = "map"
}

variable "vpnip" {
  description = "IP address of the VPN Server, Dev environment only accessible from this IP address"
}

variable "bucketprefix" {
  description = "Prefix of the S3 bucket name"
}

variable "db_password" {
  description = "The password for the database"
}

variable "db_user" {
  description = "The username for the database"
}

variable "keyname" {
  description = "Key pair to access EC2 servers"
}

variable "publickeypath" {
  description = "Path to public key to access EC2 servers"
}

variable "dev_instance_type" {
  description = "Instance type of Dev EC2 server"
}

variable "dev_ami" {
  description = "AMI to create Dev EC2 server"
}

variable "domain_name" {
  description = "Internet domain for this environment"
}
