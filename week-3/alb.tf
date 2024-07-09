resource "aws_lb" "my-tf-alb" {
  name               = "my-tf-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_security_group.id]
  subnets            = module.vpc.public-subnet-ids
}

resource "aws_lb_listener" "http-traffic" {
  load_balancer_arn = aws_lb.my-tf-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-tf-alb-target-group.arn
  }
}

# resource "aws_lb_listener_rule" "http-traffic-listener-rule" {
#   listener_arn = aws_lb_listener.http-traffic.arn
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.my-tf-alb-target-group.arn
#   }
#   condition {
#     path_pattern {
#       # The appropriate path for my needs is "/" but that's already covered by the aws_lb_listener
#       values = ["/"]
#     }
#   }
# }

resource "aws_lb_target_group" "my-tf-alb-target-group" {
  name     = "my-tf-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  # The following are all default values and not required
  # protocol_version = "HTTP1"
  # target_type      = "instance"
  # ip_address_type  = "ipv4"
}

# I used count=2 to consolidate the 2 resources that I was using before
resource "aws_lb_target_group_attachment" "target-ec2" {
  count            = 2
  target_group_arn = aws_lb_target_group.my-tf-alb-target-group.arn
  target_id        = aws_instance.private-instances[count.index].id
  # send HTTP traffic from the ALB to the EC2s' NestJS port
  # port             = 80
  port = 3000
}

# resource "aws_lb_target_group_attachment" "my-zone-1-target" {
#   target_group_arn = aws_lb_target_group.my-tf-alb-target-group.arn
#   target_id        = aws_instance.zone-1-private.id
#   port             = 80
# }

# resource "aws_lb_target_group_attachment" "my-zone-2-target" {
#   target_group_arn = aws_lb_target_group.my-tf-alb-target-group.arn
#   target_id        = aws_instance.zone-2-private.id
#   port             = 80
# }
