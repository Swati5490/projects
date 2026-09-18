# Compute Module - variables.tf

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "default_node_pool_name" {
  description = "Name of the default node pool"
  type        = string
  default     = "systempool"
}

variable "default_node_pool_count" {
  description = "Number of nodes in default pool"
  type        = number
  default     = 3
}

variable "default_node_pool_vm_size" {
  description = "VM size for default node pool"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "network_plugin" {
  description = "Network plugin (azure, overlay, kubenet)"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "Network policy (azure, calico)"
  type        = string
  default     = "azure"
}

variable "load_balancer_sku" {
  description = "Load balancer SKU"
  type        = string
  default     = "standard"
}

variable "zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "node_pools" {
  description = "Additional AKS node pools"
  type = map(object({
    name       = string
    vm_size    = optional(string, "Standard_D2s_v3")
    node_count = optional(number, 1)
    mode       = optional(string, "User")
    zones      = optional(list(string), [])
  }))
  default = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "network_plugin_mode" {
  type    = string
  default = null
}