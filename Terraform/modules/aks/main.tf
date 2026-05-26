resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name            = "default"
    vm_size         = var.vm_size
    vnet_subnet_id  = var.vnet_subnet_id
    os_disk_size_gb = var.os_disk_size_gb

    # 注意：这里是关键改动！
    # 将 enable_auto_scaling 改为 auto_scaling_enabled [citation:3][citation:8]
    auto_scaling_enabled = var.enable_auto_scaling

    # 当启用自动缩放时，必须设置 min_count 和 max_count，但不能设置 node_count
    # 所以我们将 min_count 和 max_count 的值从变量中读取
    min_count = var.enable_auto_scaling ? var.min_nodes : null
    max_count = var.enable_auto_scaling ? var.max_nodes : null

    # 重要：当启用自动缩放时，一定不能有 node_count 参数，所以这里完全移除它
    # node_count 现在只在未启用自动缩放时通过变量传递，但既然用了自动缩放，就彻底移除

    max_pods = var.max_pods

    # 添加可用区配置
    zones = var.zones
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "alicloud_cs_managed_kubernetes" "this" {
  name                = var.cluster_name
  worker_vswitch_ids  = var.worker_vswitch_ids
  pod_vswitch_ids     = var.pod_vswitch_ids

  worker_instance_types = var.worker_instance_types
  worker_system_disk_category = var.worker_system_disk_category
  worker_system_disk_size     = var.worker_system_disk_size

  worker_number = var.worker_number
  new_nat_gateway = var.new_nat_gateway

  is_enterprise_security_group = true

  install_cloud_monitor = true

  tags = var.tags
}
