variable "resource_group_name" {
  description = "资源组名称"
  type        = string
}

variable "location" {
  description = "Azure 区域"
  type        = string
}

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

# 自动缩放相关变量
variable "enable_auto_scaling" {
  description = "是否启用节点池自动缩放"
  type        = bool
  default     = false
}

variable "min_nodes" {
  description = "最小节点数"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "最大节点数"
  type        = number
  default     = 1
}

variable "max_pods" {
  description = "每个节点的最大 Pod 数"
  type        = number
  default     = 30
}

variable "existing_vnet_name" {
  description = "现有 VNet 名称（当 create_vnet = false 时必填）"
  type        = string
  default     = "vnet-kk02-eas-devops01"
}

variable "tags" {
  description = "要应用到资源的标签"
  type        = map(string)
  default     = {}
}

variable "zones" {
  description = "可用区列表，例如 [\"1\", \"2\", \"3\"]；设置为 [] 可禁用可用区"
  type        = list(string)
  default     = null
}

# 在 modules/aks/variables.tf 中添加
variable "os_disk_size_gb" {
  description = "节点 OS 磁盘大小（GB）"
  type        = number
  default     = 30
}

variable "kubernetes_version" {
  description = "Kubernetes 版本，例如 1.29.2"
  type        = string
  default     = null # null 表示使用 AKS 默认版本
}