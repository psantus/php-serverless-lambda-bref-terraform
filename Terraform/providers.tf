## DEFAULT PROVIDER
provider "aws" {
  region  = var.aws_region
}

## DEFAULT PROVIDER
provider "aws" {
  alias = "us-east-1"
  region  = "us-east-1"
}