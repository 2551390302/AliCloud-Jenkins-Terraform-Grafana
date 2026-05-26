output "vpc_id" {
  description = "VPC ID"
  value       = alicloud_vpc.this.id
}

output "vswitch_id" {
  description = "VSwitch ID"
  value       = alicloud_vswitch.this.id
}