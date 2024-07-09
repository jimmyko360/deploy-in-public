terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.54"
    }

    http = {
      source  = "hashicorp/http"
      version = "~>3.4"
    }

    local = {
      source  = "hashicorp/local"
      version = "~>2.5"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
}

# moved to VPC module
# provider "aws" {
#   # specifying the default profile is not necessary
#   profile                  = "default"
#   shared_config_files      = ["/Users/allie/.aws/config"]
#   shared_credentials_files = ["/Users/allie/.aws/credentials"]
# }

# moved to VPC module
# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/24"
# }

# These values are read from variables.tf and get sent to vpc/main.tf
# This setup is very weird
module "vpc" {
  source = "./vpc"

  region                     = var.region
  cidr_block                 = var.cidr_block
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  app_name                   = var.app_name
}
