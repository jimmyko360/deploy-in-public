resource "aws_security_group" "my-tf-alb-sg" {
  name   = "${var.app_name}-alb-sg"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${var.app_name}-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb-allow-http-inbound-traffic" {
  security_group_id = aws_security_group.my-tf-alb-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb-allow-all-outbound-traffic" {
  security_group_id = aws_security_group.my-tf-alb-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
