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

variable "availability_zone" {
  description = "可用区 ID"
  type        = string
  default     = "cn-hangzhou-i"
}

