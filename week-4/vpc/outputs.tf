output "vpc_id" {
  value = aws_vpc.my-tf-vpc.id
}

output "availability_zones" {
  value = data.aws_availability_zones.my-tf-azs.names.*
}

output "private_subnet_ids" {
  value = aws_subnet.my-tf-private-subnets.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.my-tf-public-subnets.*.id
}