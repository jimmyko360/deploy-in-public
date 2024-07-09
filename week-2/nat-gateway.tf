resource "aws_eip" "my-terraform-elastic-ip" {
  vpc = true

  depends_on = [aws_internet_gateway.my-terraform-igw]
}

resource "aws_nat_gateway" "my-terraform-nat-gateway" {
  allocation_id = aws_eip.my-terraform-elastic-ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "my-terraform-nat-gateway"
  }

  depends_on = [aws_internet_gateway.my-terraform-igw]
}

resource "aws_route_table" "my-terraform-private-route-table" {
  vpc_id = aws_vpc.my-terraform-vpc-01.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-terraform-nat-gateway.id
  }

  tags = {
    Name = "my-terraform-private-route-table"
  }
}

resource "aws_route_table_association" "my-terraform-private-rt-asc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.my-terraform-private-route-table.id
}
