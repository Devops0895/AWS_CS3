resource "aws_vpc" "vpc_acct_A" {
  cidr_block           = "10.0.0.0/27"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  instance_tenancy     = "default"

  tags = {
    Name = "vpc_acct_A"
  }
}

resource "aws_subnet" "subnets_acct_A" {
  vpc_id            = aws_vpc.vpc_acct_A.id
  cidr_block        = "10.0.1.0/28"
  availability_zone = var.availability_zones
  tags = {
    Name = "pt-subnet-name"
  }
}

resource "aws_internet_gateway" "igw_acct_A" {
  vpc_id = aws_vpc.vpc_acct_A.id

  tags = {
    Name = "internet_gateway_acct_A"
  }
}

resource "aws_route_table" "private-rt_acct_A" {
  vpc_id = aws_vpc.vpc_acct_A.id
  tags = {
    Name = "private_route_table"
  }
}


resource "aws_route_table_association" "subnet-assoc" {
  route_table_id = aws_route_table.private-rt_acct_A.id
  subnet_id      = aws_subnet.subnets_acct_A.id

}

resource "aws_security_group" "sg_acct_A" {
  vpc_id = aws_vpc.vpc_acct_A.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "My_security_group"
  }
}
