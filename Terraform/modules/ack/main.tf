# 创建 ACK 托管集群（仅控制平面）
resource "alicloud_cs_managed_kubernetes" "this" {
  name            = var.cluster_name
  vswitch_ids     = var.worker_vswitch_ids

  # Pod VSwitch（可选，Terway 网络模式需要，Flannel 模式可省略）
  pod_vswitch_ids = length(var.pod_vswitch_ids) > 0 ? var.pod_vswitch_ids : null

  # Pod CIDR 和 Service CIDR 配置
  pod_cidr         = "10.1.0.0/16"
  service_cidr     = "10.2.0.0/20"

  new_nat_gateway = var.new_nat_gateway

  is_enterprise_security_group = true

  tags = var.tags
}

# 创建默认节点池
resource "alicloud_cs_kubernetes_node_pool" "default" {
  cluster_id     = alicloud_cs_managed_kubernetes.this.id
  node_pool_name = "${var.cluster_name}-default-pool"
  vswitch_ids    = var.worker_vswitch_ids
  instance_types = var.worker_instance_types
  desired_size   = var.worker_number

  # 系统盘配置
  system_disk_category = var.worker_system_disk_category
  system_disk_size     = var.worker_system_disk_size

  # 其他配置
  install_cloud_monitor = true
}
