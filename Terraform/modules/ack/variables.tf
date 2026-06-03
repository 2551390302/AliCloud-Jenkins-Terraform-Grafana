variable "cluster_name" {
  description = "ACK 集群名称"
  type        = string
}

variable "worker_vswitch_ids" {
  description = "Worker 节点的 VSwitch ID 列表"
  type        = list(string)
}

variable "pod_vswitch_ids" {
  description = "Pod 的 VSwitch ID 列表"
  type        = list(string)
}

variable "worker_instance_types" {
  description = "Worker 节点的实例类型列表"
  type        = list(string)
  default     = ["ecs.c6.xlarge"]
}

variable "worker_system_disk_category" {
  description = "Worker 节点系统盘类型"
  type        = string
  default     = "cloud_ssd"
}

variable "worker_system_disk_size" {
  description = "Worker 节点系统盘大小（GB）"
  type        = number
  default     = 40
}

variable "worker_number" {
  description = "Worker 节点数量"
  type        = number
  default     = 2
}

variable "new_nat_gateway" {
  description = "是否创建新的 NAT 网关"
  type        = bool
  default     = true
}

variable "tags" {
  description = "要应用到资源的标签"
  type        = map(string)
  default     = {}
}

