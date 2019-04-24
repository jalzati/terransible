#VPC Endpoint for S3
resource "aws_vpc_endpoint" "terransible_private_s3_endpoint" {

  service_name = "com.amazonaws.${var.region}.s3"
  vpc_id = "${aws_vpc.terransible_vpc.id}"

  route_table_ids = ["${aws_vpc.terransible_vpc.main_route_table_id}",
    "${aws_route_table.terransible_public_rt.id}"]

  policy = <<POLICY
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
POLICY
}

#Code S3 bucket
resource "random_id" "code_bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "terransible_code_bucket" {
  bucket = "${var.bucketprefix}-${random_id.code_bucket.dec}"
  acl = "private"
  force_destroy = true

  tags {
    Name = "Terransible Code Bucket"
    Owner = "${var.owner}"
    Department = "${var.department}"
    Environment = "${var.environment}"
  }
}