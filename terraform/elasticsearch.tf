## This file represents the storage layer

resource "aws_security_group" "elasticsearch_sg" {
  name        = "elasticsearch"
  vpc_id      = "${module.vpc.vpc_id}"
  description = "Elasticsearch"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group_rule" "elasticsearch_ingress_from_kibana" {

  security_group_id = "${aws_security_group.elasticsearch_sg.id}"
  type              = "ingress"

  source_security_group_id      = "${aws_security_group.kibana_sg.id}"
  description      = "ES port"

  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"
}

resource "aws_security_group_rule" "elasticsearch_ingress_from_logstash" {

  security_group_id = "${aws_security_group.elasticsearch_sg.id}"
  type              = "ingress"

  source_security_group_id      = "${aws_security_group.logstash_sg.id}"
  description      = "ES port"

  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"
}

resource "aws_security_group_rule" "elasticsearch_ingress_from_ecs_host" {

  security_group_id = "${aws_security_group.elasticsearch_sg.id}"
  type              = "ingress"

  source_security_group_id      = "${module.ecs_sg.this_security_group_id}"
  description      = "ES port"

  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"
}

resource "aws_security_group_rule" "elasticsearch_ingress_from_self" {

  security_group_id = "${aws_security_group.elasticsearch_sg.id}"
  type              = "ingress"
  self = true

  description      = "ES cluster access"

  from_port = 9300
  to_port   = 9300
  protocol  = "tcp"
}

resource "aws_security_group_rule" "elasticsearch_egress_to_self" {

  security_group_id = "${aws_security_group.elasticsearch_sg.id}"
  type              = "egress"
  self = true

  description      = "ES cluster access"

  from_port = 9300
  to_port   = 9300
  protocol  = "tcp"
}


resource "aws_ecs_task_definition" "elasticsearch" {
  family                = "elasticsearch"
  container_definitions = "${file("task-definitions/elasticsearch.json")}"

  requires_compatibilities = ["EC2"]
  network_mode = "awsvpc"

  volume {
    name      = "es1"
  }
}

module "elasticsearch" {
  source = "./modules/ecs-service"

  name = "elasticsearch"
  discovery_namespace_id = "${aws_service_discovery_private_dns_namespace.n.id}"
  cluster_id = "${aws_ecs_cluster.loggingv1.id}"
  task_definition = "${aws_ecs_task_definition.elasticsearch.arn}"
  subnets = "${module.vpc.public_subnets}"
  security_groups = ["${aws_security_group.elasticsearch_sg.id}"]
  desired_count = 1
}