terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.56"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source             = "./vpc"
  app_name           = var.app_name
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnet_ids  = var.public_subnet_ids
  private_subnet_ids = var.private_subnet_ids
}
