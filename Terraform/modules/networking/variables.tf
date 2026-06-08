variable "vpc_cidr_block" {
  description = "VPC 的 CIDR 块"
  type        = string
  default     = "172.16.0.0/16"
}

variable "vswitch_cidr_blocks" {
  description = "VSwitch 的 CIDR 块列表"
  type        = list(string)
  default     = ["172.16.1.0/24"]
}

variable "pod_vswitch_cidr_block" {
  description = "Pod VSwitch 的 CIDR 块"
  type        = string
  default     = "172.16.2.0/24"
}

variable "availability_zone" {
  description = "可用区 ID"
  type        = string
  default     = "cn-hangzhou-i"
}

variable "tags" {
  description = "要应用到资源的标签"
  type        = map(string)
  default     = {}
}
