# testing out resource name "aws_alb" instead of "aws_lb" with argument type="application"
# looks like it worked here and in all other places where I replaced "aws_lb" with "aws_alb"
resource "aws_alb" "my-tf-alb" {
  name            = "${var.app_name}-alb"
  security_groups = [aws_security_group.my-tf-alb-sg.id]
  subnets         = module.vpc.public_subnet_ids
}

resource "aws_alb_target_group" "my-tf-target-group" {
  name = "${var.app_name}-target-group"
  port = 80
  # testing this port nonsense
  # port     = 8000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_alb_listener" "my-tf-default-alb-listener" {
  load_balancer_arn = aws_alb.my-tf-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.my-tf-target-group.arn
  }
}

resource "aws_alb_target_group_attachment" "my-tf-alb-tgas" {
  count            = 2
  target_group_arn = aws_alb_target_group.my-tf-target-group.arn
  target_id        = aws_instance.my-tf-instances[count.index].id
  port             = 80
}
