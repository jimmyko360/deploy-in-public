resource "aws_security_group" "public_security_group" {
  name = "public_security_group"

  # Because our VPC is defined in the module we made, 
  # we have to reference the module to get it's info.
  # Remember, we get this value because we defined it the module's output.tf file
  vpc_id = module.vpc.vpc_id
}

# resource "aws_vpc_security_group_ingress_rule" "allow_public_ssh" {
#   security_group_id = aws_security_group.public_security_group.id
#   cidr_ipv4         = "${chomp(data.http.my_ip.response_body)}/32"
#   ip_protocol       = "tcp"
#   from_port         = 22
#   to_port           = 22
# }

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.public_security_group.id
  cidr_ipv4         = "${chomp(data.http.my_ip.response_body)}/32"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# resource "aws_vpc_security_group_ingress_rule" "allow_https" {
#   security_group_id = aws_security_group.public_security_group.id
#   cidr_ipv4         = "${chomp(data.http.my_ip.response_body)}/32"
#   ip_protocol       = "tcp"
#   from_port         = 443
#   to_port           = 443
# }

resource "aws_vpc_security_group_egress_rule" "allow_all_public_outbound" {
  security_group_id = aws_security_group.public_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
