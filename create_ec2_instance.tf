provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_key_pair" "mykey" {
  key_name   = "terraform_test"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGV3NgIrlAXTk1eRoA4dHsm993e1r0HartHVLr48PUeg vivek@LAPTOP-NB73E019"
}

resource "aws_security_group" "terraformtest" {
  name        = "terraform_test"
  description = "terraform instance"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "terraform_test"
  }
}

resource "aws_instance" "Demo_test" {
  ami                    = "ami-0f88e80871fd81e91"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [aws_security_group.terraformtest.id]

  tags = {
    Name = "tf_learn"
  }
}
resource "aws_eip" "myeip"{
  domain    = "vpc"
  instance  = aws_instance.Demo_test.id
}
