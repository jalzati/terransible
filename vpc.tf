#VPC
resource "aws_vpc" "terransible_vpc" {
  cidr_block = "${var.vpc_cidr}"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Terransible VPC"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "terransible_gateway" {
  vpc_id = "${aws_vpc.terransible_vpc.id}"

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Terransible VPC"
  }
}

#Route Tables
resource "aws_default_route_table" "terransible_private_rt" {
  default_route_table_id = "${aws_vpc.terransible_vpc.default_route_table_id}"

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Terransible VPC"
  }
}

resource "aws_route_table" "terransible_public_rt" {
  vpc_id = "${aws_vpc.terransible_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terransible_gateway.id}"
  }

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Terransible VPC"
  }
}