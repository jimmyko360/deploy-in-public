data "aws_availability_zones" "my-tf-azs" {
  state = "available"
}

resource "aws_subnet" "my-tf-public-subnets" {
  count             = 2
  vpc_id            = aws_vpc.my-tf-vpc.id
  availability_zone = data.aws_availability_zones.my-tf-azs.names[count.index]
  cidr_block        = var.public_subnet_ids[count.index]

  tags = {
    Name = "${var.app_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "my-tf-private-subnets" {
  count             = 2
  vpc_id            = aws_vpc.my-tf-vpc.id
  availability_zone = data.aws_availability_zones.my-tf-azs.names[count.index]
  cidr_block        = var.private_subnet_ids[count.index]

  tags = {
    Name = "${var.app_name}-private-subnet-${count.index + 1}"
  }
}
