# resource "aws_instance" "zone-1-public" {
#   ami                         = var.instance_data.linux_2023_id
#   instance_type               = var.instance_data.type
#   key_name                    = aws_key_pair.zone-1-key-pair.key_name
#   associate_public_ip_address = true
#   subnet_id                   = aws_subnet.zone-1-public.id
#   vpc_security_group_ids      = [aws_security_group.public_security_group.id]

#   tags = {
#     Name = "zone-1-public"
#   }

# }
