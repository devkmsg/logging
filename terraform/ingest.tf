#$ curl -LO https://omnitruck.chef.io/install.sh && sudo bash ./install.sh -v 13.2.20 && rm install.sh

data "aws_ami" "ingest_ami" {
  most_recent = true

  filter {
    name   = "owner-id"
    values = ["099720109477"]
  }

  filter {
    name   = "name"
    values = ["*ubuntu-bionic-18.04-amd64-server*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "ingest"

  # Launch configuration
  lc_name = "ingest-lc"

  key_name        = "cs-key"
  image_id        = "${data.aws_ami.ingest_ami.id}"
  instance_type   = "t2.micro"
  security_groups = ["${module.base_sg.this_security_group_id}"]

  root_block_device = [
    {
      volume_size = "8"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "ingest"
  vpc_zone_identifier       = ["${module.vpc.public_subnets}"]
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 0
  wait_for_capacity_timeout = 0
  user_data                 = "${file("user-data")}"

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
      value               = "ingest"
      propagate_at_launch = true
    },
  ]
}
