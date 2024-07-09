# I stole this from Johnny's GitHub, so clever
output "alb_dns_name" {
  value = aws_lb.my-tf-alb.dns_name
}
