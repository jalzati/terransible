#Security Groups

#Dev Security Group
resource "aws_security_group" "terransible_dev_sg" {
  name = "Terransible Dev"
  description = "Terransible Dev Environment"
  vpc_id = "${aws_vpc.terransible_vpc.id}"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["${var.vpnip}"]
    description = "SSH Access from VPN server"
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["${var.vpnip}"]
    description = "HTTP Access from VPN server"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags {
    Name = "Terransible Dev"
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
  }
}

#Public Security Group
resource "aws_security_group" "terransible_public_sg" {
  name = "Terransible Public"
  description = "Terransible Prod Environment"
  vpc_id = "${aws_vpc.terransible_vpc.id}"

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Only allow HTTP from the Internet"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    description = "Allow all outbound traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Terransible Public"
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
  }
}

#Private Security Group
resource "aws_security_group" "terransible_private_sg" {
  name = "Terransible Internal Traffic"
  description = "Allow all internal traffic"
  vpc_id = "${aws_vpc.terransible_vpc.id}"

  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    description = "Allow all internal traffic"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    description = "Allow all outbound traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Terransible Private"
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
  }
}

#DBNet Security Group
resource "aws_security_group" "terransible_dbnet_sg" {
  name = "Terransible DBnet Traffic"
  description = "Allow only traffic to/from DB"
  vpc_id = "${aws_vpc.terransible_vpc.id}"

  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    description = "MySQL traffic"
    security_groups = ["${aws_security_group.terransible_dev_sg.id}",
      "${aws_security_group.terransible_private_sg.id}",
      "${aws_security_group.terransible_public_sg.id}"]
  }

  tags {
    Name = "Terransible DBNet"
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
  }
}