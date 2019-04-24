#S3 Access
data "aws_iam_policy_document" "terransible_managed_statement_policy_s3" {
  statement {
    effect = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terransible_managed_policy_s3" {
  name = "terransible_managed_policy_s3"

  policy = "${data.aws_iam_policy_document.terransible_managed_statement_policy_s3.json}"
}

data "aws_iam_policy_document" "terransible_managed_statement_assume_role_policy_ec2" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "terransible_s3_access_role" {
  name               = "terransible_s3_access_role"

  assume_role_policy = "${data.aws_iam_policy_document.terransible_managed_statement_assume_role_policy_ec2.json}"
}

resource "aws_iam_instance_profile" "terransible_s3_access_profile" {
  name = "s3_access"
  role = "${aws_iam_role.terransible_s3_access_role.name}"
}

resource "aws_iam_policy_attachment" "terransible_attach_s3_policy" {
  name = "terransible_attach_s3_policy"
  roles = ["${aws_iam_role.terransible_s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.terransible_managed_policy_s3.arn}"
}