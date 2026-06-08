output "vpc_id" {
  description = "VPC ID"
  value       = alicloud_vpc.this.id
}

output "vswitch_id" {
  description = "VSwitch ID"
  value       = alicloud_vswitch.this.id
}

output "pod_vswitch_id" {
  description = "Pod VSwitch ID"
  value       = alicloud_vswitch.pod.id
}