# Moved to instances.tf

# resource "aws_instance" "zone-2-private" {
#   ami           = var.instance_data.linux_2023_id
#   instance_type = var.instance_data.type
#   # key_name                    = aws_key_pair.zone-2-key-pair.key_name
#   associate_public_ip_address = false
#   subnet_id                   = module.vpc.private-subnet-ids[1]
#   vpc_security_group_ids      = [aws_security_group.private_security_group.id]
#   user_data                   = templatefile("${path.module}/zone-2-nginx.tftpl", { zone_number = "2" })
#   user_data_replace_on_change = true

#   # Terraform can infer from this that the instance profile must
#   # be created before the EC2 instance.
#   iam_instance_profile = aws_iam_instance_profile.session-manager-instance-profile.name

#   tags = {
#     Name = "zone-2-private"
#   }
# }
