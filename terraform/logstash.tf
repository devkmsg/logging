## This file represents the ingest layer

resource "aws_security_group" "logstash_sg" {
  name        = "logstash"
  vpc_id      = "${module.vpc.vpc_id}"
  description = "Logstash"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group_rule" "logstash_egress_to_elasticsearch" {

  security_group_id = "${aws_security_group.logstash_sg.id}"
  type              = "egress"

  source_security_group_id      = "${aws_security_group.elasticsearch_sg.id}"
  description      = "ES port"

  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"
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