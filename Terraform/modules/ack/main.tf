# 创建 ACK 托管集群（仅控制平面）
resource "alicloud_cs_managed_kubernetes" "this" {
  name            = var.cluster_name
  vswitch_ids     = var.worker_vswitch_ids
  pod_vswitch_ids = var.pod_vswitch_ids

  new_nat_gateway   = var.new_nat_gateway
  resource_group_id = var.resource_group_id != "" ? var.resource_group_id : null

  is_enterprise_security_group = true

  tags = var.tags
}

# 创建默认节点池
resource "alicloud_cs_kubernetes_node_pool" "default" {
  cluster_id       = alicloud_cs_managed_kubernetes.this.id
  node_pool_name   = "${var.cluster_name}-default-pool"
  vswitch_ids      = var.worker_vswitch_ids
  instance_types   = var.worker_instance_types
  desired_size     = var.worker_number
  resource_group_id = var.resource_group_id != "" ? var.resource_group_id : null

  # 系统盘配置
  system_disk_category = var.worker_system_disk_category
  system_disk_size     = var.worker_system_disk_size

  # 其他配置
  install_cloud_monitor = true
}
