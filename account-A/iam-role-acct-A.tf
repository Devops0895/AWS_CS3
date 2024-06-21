
resource "aws_iam_role" "iam_role_cross_account_A" {
  name = "role_for_account_B"

  assume_role_policy = <<EOF

  {
    "__comment__": "Need to update with ARN of the role created in account B near resource",
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "role arn created in account B" 
    }]
}

EOF
}