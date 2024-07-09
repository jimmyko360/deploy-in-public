# I combined my 2 EC2's into 1 resource block

resource "aws_instance" "private-instances" {
  count         = 2
  ami           = var.instance_data.linux_2023_id
  instance_type = var.instance_data.type
  # key_name                    = aws_key_pair.zone-1-key-pair.key_name
  associate_public_ip_address = false
  subnet_id                   = module.vpc.private-subnet-ids[count.index]
  vpc_security_group_ids      = [aws_security_group.private_security_group.id]
  user_data                   = templatefile("${path.module}/nestjs-setup.tftpl", { zone_number = "${count.index + 1}" })
  user_data_replace_on_change = true

  # Terraform can infer from this that the instance profile must
  # be created before the EC2 instance.
  iam_instance_profile = aws_iam_instance_profile.session-manager-instance-profile.name

  tags = {
    Name = "zone-${count.index + 1}-instance"
  }
}
