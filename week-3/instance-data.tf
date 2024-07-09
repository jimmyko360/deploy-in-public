variable "instance_data" {
  type = object({
    linux_2023_id = string
    linux_2_id    = string
    type          = string
  })

  default = {
    linux_2023_id = "ami-08a0d1e16fc3f61ea"
    linux_2_id    = "ami-0eaf7c3456e7b5b68"
    type          = "t2.micro"
  }
}

data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

# If I don't need to SSH then I don't need SSH keys
# resource "tls_private_key" "zone-1-private-key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "zone-1-key-pair" {
#   key_name   = "zone-1-key-pair"
#   public_key = tls_private_key.zone-1-private-key.public_key_openssh
# }

# resource "local_sensitive_file" "zone-1-private-key" {
#   content  = tls_private_key.zone-1-private-key.private_key_openssh
#   filename = "${path.module}/${aws_key_pair.zone-1-key-pair.key_name}"
# }

# resource "tls_private_key" "zone-2-private-key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "zone-2-key-pair" {
#   key_name   = "zone-2-key-pair"
#   public_key = tls_private_key.zone-2-private-key.public_key_openssh
# }

# resource "local_sensitive_file" "zone-2-private-key" {
#   content  = tls_private_key.zone-2-private-key.private_key_openssh
#   filename = "${path.module}/${aws_key_pair.zone-2-key-pair.key_name}"
# }
