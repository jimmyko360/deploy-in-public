# moved all to VPC module

# resource "aws_route_table" "public-rt" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "public-rt"
#   }
# }

# duplicated with count=2
# resource "aws_route_table_association" "zone-1-public-rta" {
#   subnet_id      = aws_subnet.zone-1-public.id
#   route_table_id = aws_route_table.public-rt.id
# }

# duplicated with count=2
# resource "aws_route_table" "zone-1-private" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.zone-1-ngw.id
#   }

#   tags = {
#     Name = "zone-1-private-rt"
#   }
# }

# duplicated with count=2
# resource "aws_route_table_association" "zone-1-private-rta" {
#   subnet_id      = aws_subnet.zone-1-private.id
#   route_table_id = aws_route_table.zone-1-private.id
# }

# moved to VPC module
# this and the zone 1 public rta are now covered by "public-rta" count=2
# Both public route tables are the same so I only need to use 1
# resource "aws_route_table" "zone-2-public" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "zone-2-public-rt"
#   }
# }

# I made 2 public rta's with count=2
# This now references the zone 1 public route table
# resource "aws_route_table_association" "zone-2-public-rta" {
#   subnet_id      = aws_subnet.zone-2-public.id
#   route_table_id = aws_route_table.public-rt.id
# }

# resource "aws_route_table" "zone-2-private" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.zone-2-ngw.id
#   }

#   tags = {
#     Name = "zone-2-private-rt"
#   }
# }

# resource "aws_route_table_association" "zone-2-private-rta" {
#   subnet_id      = aws_subnet.zone-2-private.id
#   route_table_id = aws_route_table.zone-2-private.id
# }
