

# TODO:

#log groups
#security groups


resource "aws_ecs_cluster" "loggingv1" {
  name = "loggingv1"
}

resource "aws_service_discovery_private_dns_namespace" "n" {
  name = "local"
  vpc = "${module.vpc.vpc_id}"
}

# TODO: Add asg
#aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux/recommended

data "aws_ssm_parameter" "ecs_ami" {
  name  = "/aws/service/ecs/optimized-ami/amazon-linux/recommended"
}

# FIXME: get the above to work
locals {
  ami_id = "ami-5253c32d"
}

module "ecs_asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "loggingv1"

  # Launch configuration
  lc_name = "loggingv1-lc"

  key_name        = "cs-key"
  image_id        = "${local.ami_id}"
  instance_type   = "t2.medium"
  spot_price = 0.0139
  security_groups = ["${module.base_sg.this_security_group_id}"]

  #FIXME: add iam policy

  # Auto scaling group
  asg_name                  = "loggingv1"
  vpc_zone_identifier       = ["${module.vpc.public_subnets}"]
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  user_data                 = "${file("ecs-user-data")}"

  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key                 = "Terraform"
      value               = "true"
      propagate_at_launch = true
    },
    {
      key                 = "Purpose"
      value               = "loggingv1"
      propagate_at_launch = true
    },
  ]
}