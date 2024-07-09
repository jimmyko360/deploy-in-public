output "private_ec2_ip" {
  value = aws_instance.my-terraform-private-ec2.private_ip
}

# I couldn't find this in the Terraform docs but it does work somehow
output "public_ec2_ip" {
  value = aws_instance.my-terraform-public-ec2.public_ip
}
