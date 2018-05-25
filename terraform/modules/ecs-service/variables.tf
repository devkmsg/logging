variable "name" {
  type = "string"
  description = "Name of the service"
}

variable "discovery_namespace_id" {
  type = "string"
  description = "ID of the service discovery namespace"
}

variable "dns_ttl" {
  default = 60
  description = "DNS TTL for the discovery records"
}

variable "dns_record_type" {
  default = "A"
  description = "DNS record type; valid values: A, AAAA, SRV, CNAME"
 }

variable "dns_routing_policy" {
  default = "WEIGHTED"
  description = "Discovery DNS routing_policy; valid values: MULTIVALUE, WEIGHTED"
}

variable "cluster_id" {
  type = "string"
  description = "ECS cluster ARN"
}

variable "task_definition" {
  type = "string"
  description = "Task id"
}

variable "desired_count" {
  default = 0
  description = "Service desired_count"
}

variable "subnets" {
  type = "list"
  description = "Subnets for the container"
}

variable "security_groups" {
  type = "list"
  description = "Security groups for the container"
}