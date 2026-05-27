output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "resource_group_id" {
  description = "资源组 ID"
  value       = local.resource_group_id
}

output "vswitch_id" {
  description = "VSwitch ID"
  value       = module.networking.vswitch_id
}

output "ack_cluster_id" {
  description = "ACK 集群 ID"
  value       = module.ack.cluster_id
}

output "kubeconfig" {
  description = "Kubernetes 配置文件"
  value       = module.ack.kubeconfig
  sensitive   = true
}

output "acr_instance_id" {
  description = "ACR 实例 ID"
  value       = alicloud_cr_instance.acr.id
}