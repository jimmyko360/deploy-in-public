resource "aws_internet_gateway" "my-tf-igw" {
  vpc_id = aws_vpc.my-tf-vpc.id
}

resource "aws_route_table" "my-tf-public-rt" {
  vpc_id = aws_vpc.my-tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-tf-igw.id
  }

  tags = {
    Name = "${var.app_name}-public-rt"
  }
}

resource "aws_route_table_association" "my-tf-public-rtas" {
  count          = 2
  route_table_id = aws_route_table.my-tf-public-rt.id
  subnet_id      = aws_subnet.my-tf-public-subnets[count.index].id
}


