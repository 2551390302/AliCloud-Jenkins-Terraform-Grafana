resource "alicloud_cs_managed_kubernetes" "this" {
  name           = var.cluster_name
  vswitch_ids    = var.worker_vswitch_ids
  pod_vswitch_ids = var.pod_vswitch_ids

  worker_instance_types = var.worker_instance_types
  worker_number         = var.worker_number
  new_nat_gateway       = var.new_nat_gateway
  resource_group_id     = var.resource_group_id != "" ? var.resource_group_id : null

  is_enterprise_security_group = true

  tags = var.tags
}
