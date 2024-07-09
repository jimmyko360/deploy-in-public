# moved all to VPC module
# duplicated eip's and ngw's with count=2

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main.id
# }

# resource "aws_eip" "zone-1-eip" {
#   domain = "vpc"
# }

# resource "aws_eip" "zone-2-eip" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "zone-1-ngw" {
#   allocation_id = aws_eip.zone-1-eip.id
#   subnet_id     = aws_subnet.zone-1-public.id

#   tags = {
#     Name = "zone-1-ngw"
#   }

#   depends_on = [aws_internet_gateway.igw]
# }

# resource "aws_nat_gateway" "zone-2-ngw" {
#   allocation_id = aws_eip.zone-2-eip.id
#   subnet_id     = aws_subnet.zone-2-public.id

#   tags = {
#     Name = "zone-2-ngw"
#   }

#   depends_on = [aws_internet_gateway.igw]
# }
