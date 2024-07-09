terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_group" "admin-test-group-2" {
  name = "admin-test-group-2"
}

resource "aws_iam_user" "test2" {
  name = "test2"
}

resource "aws_vpc" "my-terraform-vpc-01" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "my-terraform-vpc-01"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my-terraform-vpc-01.id
  cidr_block        = "10.0.0.0/25"
  availability_zone = "us-east-1a"

  tags = {
    Name = "my-terraform-public-subnet-01"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my-terraform-vpc-01.id
  cidr_block        = "10.0.0.128/25"
  availability_zone = "us-east-1a"

  tags = {
    Name = "my-terraform-private-subnet-01"
  }
}

resource "aws_internet_gateway" "my-terraform-igw" {
  vpc_id = aws_vpc.my-terraform-vpc-01.id

  tags = {
    Name = "my-terraform-igw"
  }
}

resource "aws_route_table" "my-terraform-public-route-table" {
  vpc_id = aws_vpc.my-terraform-vpc-01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-terraform-igw.id
  }

  tags = {
    Name = "my-terraform-public-route-table"
  }
}

resource "aws_route_table_association" "my-terraform-public-rt-asc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.my-terraform-public-route-table.id
}

resource "tls_private_key" "my-terraform-keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my-terraform-keypair-02" {
  key_name   = "my-terraform-keypair-02"
  public_key = tls_private_key.my-terraform-keypair.public_key_openssh

  tags = {
    Name = "my-terraform-keypair-02"
  }
}

output "my-terraform-private-key" {
  value     = tls_private_key.my-terraform-keypair.private_key_pem
  sensitive = true
}

resource "local_sensitive_file" "my-terraform-private-pem" {
  content  = tls_private_key.my-terraform-keypair.private_key_pem
  filename = "${path.module}/my-terraform-private-pem"
}

data "http" "my-ip" {
  url = "http://icanhazip.com"
}

resource "aws_instance" "my-terraform-public-ec2" {
  ami                         = "ami-00beae93a2d981137"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.my-terraform-public-sg.id]
  key_name                    = aws_key_pair.my-terraform-keypair-02.key_name
  associate_public_ip_address = true
  user_data                   = templatefile("userdata.tftpl", { private_ip = aws_instance.my-terraform-private-ec2.private_ip })
  user_data_replace_on_change = true

  # provisioner "file" {
  #   source      = "reverse-proxy.conf"
  #   destination = "/tmp/reverse-proxy.conf"


  #   connection {
  #     type        = "ssh"
  #     port        = 22
  #     host        = self.public_ip
  #     user        = "ec2-user"
  #     private_key = file("my-terraform-private-pem")
  #   }
  # }

  tags = {
    Name = "my-terraform-public-ec2"
  }

  depends_on = [aws_instance.my-terraform-private-ec2]
}

resource "aws_security_group" "my-terraform-public-sg" {
  name        = "my-terraform-public-sg"
  description = "sg created by terraform for public ec2"
  vpc_id      = aws_vpc.my-terraform-vpc-01.id

  tags = {
    Name = "my-terraform-public-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow-inbound-http-traffic" {
  security_group_id = aws_security_group.my-terraform-public-sg.id
  cidr_ipv4         = "${chomp(data.http.my-ip.response_body)}/32"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow-inbound-ssh-traffic" {
  security_group_id = aws_security_group.my-terraform-public-sg.id
  cidr_ipv4         = "${chomp(data.http.my-ip.response_body)}/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow-all-outbound-public-traffic" {
  security_group_id = aws_security_group.my-terraform-public-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
