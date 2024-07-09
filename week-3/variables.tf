variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/24"
}

variable "public_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.0/26", "10.0.0.64/26"]
}

variable "private_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.128/26", "10.0.0.192/26"]
}

variable "app_name" {
  type    = string
  default = "my-terraform"
}
