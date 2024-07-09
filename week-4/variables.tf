variable "region" {
  type    = string
  default = "us-east-1"
}

variable "app_name" {
  type    = string
  default = "jyk-tf"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/24"
}

variable "public_subnet_ids" {
  type    = list(string)
  default = ["10.0.0.0/26", "10.0.0.64/26"]
}

variable "private_subnet_ids" {
  type    = list(string)
  default = ["10.0.0.128/26", "10.0.0.192/26"]
}

variable "instance_data" {
  type = object({
    image_id = string
    type     = string
  })

  default = {
    image_id = "ami-08a0d1e16fc3f61ea"
    type     = "t2.micro"
  }
}
