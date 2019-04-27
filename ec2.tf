#Dev Server

resource "aws_eip" "dev_elasticip" {
  vpc = true
  instance = "${aws_instance.terransible_dev_server.id}"

  tags {
    Name = "Terransible Dev Server"
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
  }
}

resource "aws_key_pair" "terransible_keypair" {
  key_name   = "${var.keyname}"
  public_key = "${file(var.publickeypath)}"
}

resource "aws_instance" "terransible_dev_server" {
  instance_type = "${var.dev_instance_type}"
  ami           = "${var.dev_ami}"

  tags {
    Name = "Terransible Dev Server"
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
  }

  key_name               = "${aws_key_pair.terransible_keypair.id}"
  vpc_security_group_ids = ["${aws_security_group.terransible_dev_sg.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.terransible_s3_access_profile.id}"
  subnet_id              = "${aws_subnet.terransible_public_subnet_1.id}"

  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > aws_hosts
[dev]
${aws_instance.terransible_dev_server.public_ip}
[dev:vars]
s3code=${aws_s3_bucket.terransible_code_bucket.bucket}
domain=${var.domain_name}
EOF
EOD
  }

  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.terransible_dev_server.id} --profile sysadmin && ansible-playbook -i aws_hosts ansible/wordpress.yml"
  }
}