## This file represents the display layer

variable "allow_from" {
  type = "list"
  description = "Allow access from the internet"
}

resource "aws_security_group" "kibana_sg" {
  name        = "kibana"
  vpc_id      = "${module.vpc.vpc_id}"
  description = "Kibana"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group_rule" "kibana_ingress_from_internet" {

  security_group_id = "${aws_security_group.kibana_sg.id}"
  type              = "ingress"

  cidr_blocks      = ["${var.allow_from}"]
  description      = "Kibana port"

  from_port = 5601
  to_port   = 5601
  protocol  = "tcp"
}

resource "aws_security_group_rule" "kibana_egress_to_elasticsearch" {

  security_group_id = "${aws_security_group.kibana_sg.id}"
  type              = "egress"

  source_security_group_id      = "${aws_security_group.elasticsearch_sg.id}"
  description      = "ES port"

  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"
}

resource "aws_ecs_task_definition" "kibana" {
  family                = "kibana"
  container_definitions = "${file("task-definitions/kibana.json")}"

  requires_compatibilities = ["EC2"]
  network_mode = "awsvpc"
}

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