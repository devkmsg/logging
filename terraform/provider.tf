terraform {
  backend "s3" {
    bucket = "logging-tf-backend"
    key    = "main"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
