resource "aws_db_instance" "terransible_db" {
  instance_class = "db.t2.micro"
  engine = "mysql"
  engine_version = "5.7"
  name = "terransible_db"
  username = "${var.db_user}"
  password = "${var.db_password}"
  db_subnet_group_name = "${aws_db_subnet_group.terransible_db_subnet_group.name}"
  vpc_security_group_ids = ["${aws_security_group.terransible_dbnet_sg.id}"]

  allocated_storage = 10
  storage_type = "gp2"
  allow_major_version_upgrade = true
  apply_immediately = true
  auto_minor_version_upgrade = true
  backup_retention_period = "3"
  deletion_protection = false
  skip_final_snapshot = true

  tags {
    Name = "Terransible Database"
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
  }
}