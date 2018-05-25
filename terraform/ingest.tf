## This file represents the ingest layer

module "ingest_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "ingest-p01"
  vpc_id      = "${module.vpc.vpc_id}"
  description = "Ingest p01"

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