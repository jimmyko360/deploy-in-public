output "aws_availability_zones" {
  value = data.aws_availability_zones.available.names
}

# In order to use the resources defined in this module outside
# e.g. within files in the root directory,
# we need to define it as an output here
output "vpc_id" {
  value = aws_vpc.main.id
}

# I guess we don't use count.index here for multiple instances
# I guess this outputs a list of the ID's so we don't have to reference ID again when using this
output "public-subnet-ids" {
  value = aws_subnet.public-subnets.*.id
}

output "private-subnet-ids" {
  value = aws_subnet.private-subnets.*.id
}
