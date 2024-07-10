resource "aws_vpc" "my-tf-vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.app_name}-vpc"
  }
}
