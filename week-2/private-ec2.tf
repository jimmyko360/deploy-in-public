variable "EC2_AMI" {
  default = "ami-00beae93a2d981137"
}

variable "EC2_TYPE" {
  default = "t2.micro"
}

resource "aws_instance" "my-terraform-private-ec2" {
  ami                    = var.EC2_AMI
  instance_type          = var.EC2_TYPE
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.my-terraform-private-sg.id]
  key_name               = aws_key_pair.my-terraform-keypair-02.key_name
  # user_data              = file("private-ec2-startup.tpl")
  user_data                   = templatefile("${path.module}/nestjs-startup.tftpl", { region = "us-east-1", ecr_repo = "105924135715.dkr.ecr.us-east-1.amazonaws.com/jyk-tf-images" })
  user_data_replace_on_change = true

  tags = {
    Name = "my-terraform-private-ec2"
  }
}

resource "aws_security_group" "my-terraform-private-sg" {
  name        = "my-terraform-private-sg"
  description = "sg created by terraform for private ec2"
  vpc_id      = aws_vpc.my-terraform-vpc-01.id

  tags = {
    Name = "my-terraform-private-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow-public-ec2-ssh-only" {
  security_group_id            = aws_security_group.my-terraform-private-sg.id
  referenced_security_group_id = aws_security_group.my-terraform-public-sg.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow-public-ec2-http-only" {
  security_group_id            = aws_security_group.my-terraform-private-sg.id
  referenced_security_group_id = aws_security_group.my-terraform-public-sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow-all-outbound-private-traffic" {
  security_group_id = aws_security_group.my-terraform-private-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
