resource "aws_instance" "my-tf-instances" {
  count                  = 2
  ami                    = var.instance_data.image_id
  instance_type          = var.instance_data.type
  subnet_id              = module.vpc.private_subnet_ids[count.index]
  iam_instance_profile   = aws_iam_instance_profile.my-tf-ecr-ec2-profile.name
  vpc_security_group_ids = [aws_security_group.my-tf-ec2-sg.id]
  # user_data                   = templatefile("${path.module}/startup-script.tftpl", { region = var.region, ecr_repo = aws_ecr_repository.my-tf-images.repository_url })
  user_data_replace_on_change = true
}
