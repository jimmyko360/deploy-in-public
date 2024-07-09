provider "aws" {
  # region = var.region
  profile                  = "default"
  shared_config_files      = ["/Users/allie/.aws/config"]
  shared_credentials_files = ["/Users/allie/.aws/credentials"]
}
