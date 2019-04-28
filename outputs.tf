output "dev_server_public_ip" {
  value = "${aws_instance.terransible_dev_server.public_ip}"
}
