resource "aws_eip" "my-tf-ngw-eips" {
  count  = 2
  domain = "vpc"
}

resource "aws_nat_gateway" "my-tf-ngws" {
  count         = 2
  allocation_id = aws_eip.my-tf-ngw-eips[count.index].id
  subnet_id     = aws_subnet.my-tf-public-subnets[count.index].id

  tags = {
    Name = "${var.app_name}-ngw-${count.index + 1}"
  }

  depends_on = [aws_eip.my-tf-ngw-eips]
}

resource "aws_route_table" "my-tf-private-rt" {
  count  = 2
  vpc_id = aws_vpc.my-tf-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-tf-ngws[count.index].id
  }

  tags = {
    Name = "${var.app_name}-private-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "my-tf-private-rtas" {
  count          = 2
  route_table_id = aws_route_table.my-tf-private-rt[count.index].id
  subnet_id      = aws_subnet.my-tf-private-subnets[count.index].id
}
