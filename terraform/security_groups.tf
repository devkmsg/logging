module "base_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "base"
  description = "Base Security group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["76.119.218.144/32"] # FIXME: set this dynamic
  ingress_rules       = ["ssh-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = []
  egress_rules = ["dns-udp", "dns-tcp", "https-443-tcp"]
  egress_with_cidr_blocks = [
    {
      from_port   = 123
      to_port     = 123
      protocol    = "udp"
      description = "NTP"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
