output "kubeconfig" {
  value     = alicloud_cs_managed_kubernetes.this.kube_config
  sensitive = true
}

output "cluster_id" {
  description = "ACK 集群 ID"
  value       = alicloud_cs_managed_kubernetes.this.id
}