resource "aws_service_discovery_service" "this" {
  name = "${var.name}"
  dns_config {
    namespace_id = "${var.discovery_namespace_id}"
    dns_records {
      ttl = "${var.dns_ttl}"
      type = "${var.dns_record_type}"
    }
    routing_policy = "${var.dns_routing_policy}"
  }

  health_check_custom_config {
    failure_threshold = 2
  }
}

resource "aws_ecs_service" "this" {
  name            = "${var.name}"
  cluster         = "${var.cluster_id}"
  task_definition = "${var.task_definition}"
  desired_count   = "${var.desired_count}"

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  network_configuration {
    subnets = ["${var.subnets}"]
    security_groups = ["${var.security_groups}"]
  }

  service_registries {
    registry_arn = "${aws_service_discovery_service.this.arn}"
  }
}