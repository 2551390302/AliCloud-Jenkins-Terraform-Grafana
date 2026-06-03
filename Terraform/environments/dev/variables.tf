variable "alicloud_access_key" {
  description = "阿里云 Access Key ID"
  type        = string
  sensitive   = true
}

variable "alicloud_secret_key" {
  description = "阿里云 Access Key Secret"
  type        = string
  sensitive   = true
}

variable "alicloud_region" {
  description = "阿里云区域"
  type        = string
  default     = "cn-chengdu"
}

variable "alicloud_availability_zone" {
  description = "阿里云可用区"
  type        = string
  default     = "cn-chengdu-a"
}

variable "feishu_webhook_url" {
  description = "飞书群机器人的 Webhook 地址"
  type        = string
  sensitive   = true
}