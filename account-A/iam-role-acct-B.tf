

resource "aws_iam_role" "iam_role_account_B" {
  name = "role_for_account_B"

  assume_role_policy = <<EOF

  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::*"]
        }
    ]
}

EOF
}