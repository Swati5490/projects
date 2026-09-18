variable "virtual_machines" {
  description = "Linux virtual machines and their network and data disk settings"
  type = map(object({
    name                         = string
    nic_name                     = string
    size                         = optional(string, "Standard_D2s_v5")
    subnet_key                   = optional(string, "databases")
    admin_username               = optional(string, "azureuser")
    os_disk_size_gb              = optional(number, 64)
    os_disk_storage_account_type = optional(string, "Premium_LRS")
    data_disks = optional(map(object({
      name                 = string
      size                 = number
      lun                  = number
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "Premium_LRS")
    })), {})
  }))
}

variable "subnet_ids" {
  description = "Subnet IDs keyed by the root subnet configuration key"
  type        = map(string)
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "admin_ssh_public_key" {
  description = "Optional SSH public key for Linux VM administration"
  type        = string
  default     = null
  sensitive   = true
}

variable "image_publisher" {
  type    = string
  default = "Canonical"
}

variable "image_offer" {
  type    = string
  default = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  type    = string
  default = "22_04-lts-gen2"
}

variable "image_version" {
  type    = string
  default = "latest"
}
