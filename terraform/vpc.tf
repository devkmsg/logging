module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "LoggingVPC"
  cidr = "10.0.0.0/24"

  azs            = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.0.0/28", "10.0.0.16/28"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
