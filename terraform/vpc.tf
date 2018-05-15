module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "LoggingVPC"
  cidr = "10.0.0.0/24"

  azs            = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.0.0/28", "10.0.0.16/28"]

  enable_s3_endpoint = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_network_acl" "public" {
  vpc_id = "${module.vpc.vpc_id}"
  subnet_ids = ["${module.vpc.public_subnets}"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${module.vpc.default_network_acl_id}"
}

resource "aws_network_acl_rule" "all-in" {
  network_acl_id = "${aws_network_acl.public.id}"
  rule_number    = 100
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "all-out" {
  network_acl_id = "${aws_network_acl.public.id}"
  rule_number    = 100
  egress         = true
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}