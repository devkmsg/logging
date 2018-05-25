## This file represents the display layer

module "display_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "display-p01"
  vpc_id      = "${module.vpc.vpc_id}"
  description = "Display p01"

  ingress_cidr_blocks = ["76.119.218.144/32"] # FIXME: set this dynamic
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  egress_ipv6_cidr_blocks = []
  egress_with_source_security_group_id = [
    {
      rule                     = "elasticsearch-rest-tcp"
      source_security_group_id = "${module.store_sg.this_security_group_id}"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

#resource "aws_ecs_task_definition" "elasticsearch" {
#  family                = "elasticsearch"
#  container_definitions = "${file("task-definitions/elasticsearch.json")}"
#
#  requires_compatibilities = ["EC2"]
#  network_mode = "awsvpc"
#
#  volume {
#    name      = "es1"
#  }
#}
#
#module "elasticsearch-p01" {
#  source = "./modules/ecs-service"
#
#  name = "elasticsearch-p01"
#  discovery_namespace_id = "${aws_service_discovery_private_dns_namespace.n.id}"
#  cluster_id = "${aws_ecs_cluster.loggingv1.id}"
#  task_definition = "${aws_ecs_task_definition.elasticsearch.arn}"
#  subnets = "${module.vpc.public_subnets}"
#  security_groups = ["sg-c0e68488"] # FIXME
#}