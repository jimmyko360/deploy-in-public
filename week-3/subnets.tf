# moved all to VPC module

# data "aws_availability_zones" "available" {
#   state = "available"
# }

# resource "aws_subnet" "zone-1-public" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.0.0/26"
#   availability_zone = data.aws_availability_zones.available.names[0]

#   tags = {
#     Name = "zone-1-public"
#   }
# }

# resource "aws_subnet" "zone-1-private" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.0.64/26"
#   availability_zone = data.aws_availability_zones.available.names[0]

#   tags = {
#     Name = "zone-1-private"
#   }
# }

# resource "aws_subnet" "zone-2-public" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.0.128/26"
#   availability_zone = data.aws_availability_zones.available.names[1]

#   tags = {
#     Name = "zone-2-public"
#   }
# }

# resource "aws_subnet" "zone-2-private" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.0.192/26"
#   availability_zone = data.aws_availability_zones.available.names[1]

#   tags = {
#     Name = "zone-2-private"
#   }
# }
