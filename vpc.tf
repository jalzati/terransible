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
    Name = "Terransible Internet Gateway"
  }
}

#Route Tables
resource "aws_default_route_table" "terransible_private_rt" {
  default_route_table_id = "${aws_vpc.terransible_vpc.default_route_table_id}"

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Terransible Default (Private) RT"
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
    Name = "Terransible Public RT"
  }
}

#Subnets

#Public Subnets
resource "aws_subnet" "terransible_public_subnet_1" {
  cidr_block = "${var.subnet_cidrs["public1"]}"
  vpc_id = "${aws_vpc.terransible_vpc.id}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available_azs.names[0]}"

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Terransible Public1 Subnet"
  }
}

resource "aws_subnet" "terransible_public_subnet_2" {
  cidr_block = "${var.subnet_cidrs["public2"]}"
  vpc_id = "${aws_vpc.terransible_vpc.id}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available_azs.names[1]}"

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Terransible Public2 Subnet"
  }
}

#Private Subnets
resource "aws_subnet" "terransible_private_subnet_1" {
  cidr_block = "${var.subnet_cidrs["private1"]}"
  vpc_id = "${aws_vpc.terransible_vpc.id}"
  map_public_ip_on_launch = false
  availability_zone = "${data.aws_availability_zones.available_azs.names[0]}"

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Terransible Private1 Subnet"
  }
}

resource "aws_subnet" "terransible_private_subnet_2" {
  cidr_block = "${var.subnet_cidrs["private2"]}"
  vpc_id = "${aws_vpc.terransible_vpc.id}"
  map_public_ip_on_launch = false
  availability_zone = "${data.aws_availability_zones.available_azs.names[1]}"

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Terransible Private2 Subnet"
  }
}

#DB Subnets
resource "aws_subnet" "terransible_db_subnet_1" {
  cidr_block = "${var.subnet_cidrs["dbnet1"]}"
  vpc_id = "${aws_vpc.terransible_vpc.id}"
  map_public_ip_on_launch = false
  availability_zone = "${data.aws_availability_zones.available_azs.names[0]}"

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Terransible DBnet1 Subnet"
  }
}

resource "aws_subnet" "terransible_db_subnet_2" {
  cidr_block = "${var.subnet_cidrs["dbnet2"]}"
  vpc_id = "${aws_vpc.terransible_vpc.id}"
  map_public_ip_on_launch = false
  availability_zone = "${data.aws_availability_zones.available_azs.names[1]}"

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Terransible DBnet2 Subnet"
  }
}

resource "aws_subnet" "terransible_db_subnet_3" {
  cidr_block = "${var.subnet_cidrs["dbnet3"]}"
  vpc_id = "${aws_vpc.terransible_vpc.id}"
  map_public_ip_on_launch = false
  availability_zone = "${data.aws_availability_zones.available_azs.names[1]}"

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Terransible DBnet3 Subnet"
  }
}

#RDS Subnet Group
resource "aws_db_subnet_group" "terransible_db_subnet_group" {
  subnet_ids = ["${aws_subnet.terransible_db_subnet_1.id}",
    "${aws_subnet.terransible_db_subnet_2.id}",
    "${aws_subnet.terransible_db_subnet_3.id}"]

  tags {
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
    Name = "Terransible DB Subnet Group"
  }
}

#RT Associations
resource "aws_route_table_association" "public1_assoc" {
  subnet_id = "${aws_subnet.terransible_public_subnet_1.id}"
  route_table_id = "${aws_route_table.terransible_public_rt.id}"
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id = "${aws_subnet.terransible_public_subnet_2.id}"
  route_table_id = "${aws_route_table.terransible_public_rt.id}"
}

resource "aws_route_table_association" "private1_assoc" {
  subnet_id = "${aws_subnet.terransible_private_subnet_1.id}"
  route_table_id = "${aws_default_route_table.terransible_private_rt.id}"
}

resource "aws_route_table_association" "private2_assoc" {
  subnet_id = "${aws_subnet.terransible_private_subnet_2.id}"
  route_table_id = "${aws_default_route_table.terransible_private_rt.id}"
}
