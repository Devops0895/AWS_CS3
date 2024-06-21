
locals {
  KeyPair = "private-key"
}

resource "aws_iam_instance_profile" "demo-profile" {
  name = "demo_profile"
  role = aws_iam_role.iam_role_cross_account_A.name
}

resource "tls_private_key" "private" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name = local.KeyPair
  #public_key = file("~/.ssh/private-key.pub")
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCs+NZZFh9i2mnP+0n0+uVE/7mRyEoYLsV/SLTCnvcnj8BrTBnftzaD5/JhNV+d2lv6PMbYQfKJvvzLqMhVrBohsMnd2iY/Pz+mCIbOGOrMD5McOX3PXuIbffBKOy7hCJFbmmjFMXy7PF6biy1MIiP3yjAUcWv7aOg1/5JzL8GTmQHDnx42Qgt0Y07T71oXioUkv1Aix9YH6wWZElwQXa38+zoZUb8JnaZmlSNyWlUpeNFJ1g977RyeSylahLaTPsHoxDZ/QGrvoKQVtJ5SSDPuK8PhdRlgTJB4Q+LDAewAW6+mQbK8pbQ9xSJh7J5oTSFfgGzHpuPdUE70DJT6t9USq2S+mHAGvN1jDbfhyWX/gg0sIpAhwrM015QgGdc1SpCJrZ5GCwPQ7TQluVnAXeWGl3U4LCdjWHXLJY1fiYRRBIg2Be3tI8ooiHoZDnwwU9ek51QLhTxt8foLFcjNsLGi8YG4mI6lAaPg32rQKeouU5/EUpalaMa0ioIrTJ1ANks= MUMBAI1+SaiS2@CTAADPG02X1Z2"
}

resource "aws_instance" "instances" {
  ami                    = "ami-089313d40efd067a9" # Replace with your desired AMI ID
  instance_type          = "t2.small"
  subnet_id              = aws_subnet.subnets_acct_A.id
  vpc_security_group_ids = [aws_security_group.sg_acct_A.id]
  iam_instance_profile   = aws_iam_instance_profile.demo-profile.name
  key_name               = aws_key_pair.generated_key.key_name

  # connection {
  #   type        = "ssh"
  #   user        = "ec2-user"
  #   private_key = file(aws_key_pair.generated_key)
  #   host        = self.private_ip
  # }

  tags = {
    Name = "instance-1"
  }


  # # Copies the myapp.conf file to /etc/myapp.conf
  # provisioner "file" {
  #   source      = "/C/Sudheer/Assignments/AWS-shell-script-s3/Terraform Code/userdata.sh"
  #   destination = "/opt/userdata.sh"
  # }

  user_data = <<-EOF
    
  sudo yum upgrade -y
  sudo yum update -y
  sudo ssh-keygen -y
  sudo yum install -y awslogs

  #to modify the default location name and set it to current location
  sed -i "s/us-east-1/us-west-2/g" /etc/awslogs/awscli.conf

  #start the aws logs agent
  sudo systemctl start awslogsd

  #start the service at each system boot.
  sudo systemctl enable awslogsd.service

  echo -e "#!/bin/bash\#this script is for access the s3 buckets present in the appropriate account\aws s3 ec2-access-logging-bucket-112233 ls >> /home/ec2-user/userdata.sh
  sudo ./home/ec2-user/userdata.sh
  EOF
}
