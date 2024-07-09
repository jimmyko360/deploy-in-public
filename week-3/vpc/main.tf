# need to fix all references to VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

data "aws_availability_zones" "available" {
  state = "available"
}

# need to fix all references to subnets
resource "aws_subnet" "public-subnets" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "zone-${count.index + 1}-public"
  }
}

resource "aws_subnet" "private-subnets" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "zone-${count.index + 1}-private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public-rta" {
  count          = 2
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_eip" "ngw-eip" {
  count  = 2
  domain = "vpc"

  tags = {
    Name = "${var.app_name}-eip=${count.index + 1}"
  }
  # Callie adds this line here. I've never used it before and have been fine
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "ngw" {
  count         = 2
  allocation_id = aws_eip.ngw-eip[count.index].id
  subnet_id     = aws_subnet.public-subnets[count.index].id

  tags = {
    Name = "zone-${count.index + 1}-ngw"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private-rta" {
  count  = 2
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[count.index].id
  }

  tags = {
    Name = "zone-${count.index + 1}-private-rt"
  }
}

resource "aws_route_table_association" "zone-1-private-rta" {
  count          = 2
  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.private-rta[count.index].id
}
