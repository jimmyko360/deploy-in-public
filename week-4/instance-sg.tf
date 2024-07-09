resource "aws_security_group" "my-tf-ec2-sg" {
  name   = "${var.app_name}-ec2-sg"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${var.app_name}-ec2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2-allow-http-inbound-traffic" {
  security_group_id            = aws_security_group.my-tf-ec2-sg.id
  referenced_security_group_id = aws_security_group.my-tf-alb-sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

# ALB Target group test
# resource "aws_vpc_security_group_ingress_rule" "test" {
#   security_group_id            = aws_security_group.my-tf-ec2-sg.id
#   referenced_security_group_id = aws_security_group.my-tf-alb-sg.id
#   from_port                    = 8000
#   to_port                      = 8000
#   ip_protocol                  = "tcp"
# }

resource "aws_vpc_security_group_egress_rule" "ec2-allow-all-outbound-traffic" {
  security_group_id = aws_security_group.my-tf-ec2-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
