provider "aws" {
  region = var.aws_region
  # credentials are taken from env/AWS CLI profile
}
