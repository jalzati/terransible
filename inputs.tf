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