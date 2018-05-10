module "base_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "base"
  description = "Base Security group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["76.119.218.144/32"] # FIXME: set this dynamic
  ingress_rules       = ["ssh-tcp"]
}
