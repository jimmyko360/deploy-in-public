resource "aws_security_group" "private_security_group" {
  name   = "private_security_group"
  vpc_id = module.vpc.vpc_id
}

# SSH is not needed when using Session Manager
# resource "aws_vpc_security_group_ingress_rule" "allow_private_ssh" {
#   security_group_id            = aws_security_group.private_security_group.id
#   referenced_security_group_id = aws_security_group.public_security_group.id
#   ip_protocol                  = "tcp"
#   from_port                    = 22
#   to_port                      = 22
# }

# the ALB requires access to port 80
resource "aws_vpc_security_group_ingress_rule" "allow_private_http" {
  security_group_id            = aws_security_group.private_security_group.id
  referenced_security_group_id = aws_security_group.public_security_group.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

# Need to allow incoming traffic to NestJS's port
resource "aws_vpc_security_group_ingress_rule" "nestjs-port" {
  security_group_id            = aws_security_group.private_security_group.id
  referenced_security_group_id = aws_security_group.public_security_group.id
  ip_protocol                  = "tcp"
  from_port                    = 3000
  to_port                      = 3000
}

resource "aws_vpc_security_group_egress_rule" "allow_all_private_outbound" {
  security_group_id = aws_security_group.private_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
