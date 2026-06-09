output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
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

# output "acr_namespace" {
#   description = "ACR 命名空间"
#   value       = alicloud_cr_namespace.acr.name
# }