variable "name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "container_app_environment_id" {
  type = string
}

variable "image" {
  type = string
}

variable "cpu" {
  type    = number
  default = 0.5
}

variable "memory" {
  type    = string
  default = "1Gi"
}

variable "revision_mode" {
  type    = string
  default = "Single"

  validation {
    condition = contains(
      ["Single", "Multiple"],
      var.revision_mode
    )

    error_message = "revision_mode must be Single or Multiple."
  }
}

variable "min_replicas" {
  type    = number
  default = 1
}

variable "max_replicas" {
  type    = number
  default = 2
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "managed_identity_id" {
  type    = string
  default = null
}

variable "ingress" {
  type = object({
    external_enabled           = bool
    target_port                = number
    transport                  = optional(string, "auto")
    allow_insecure_connections = optional(bool, false)
  })

  default = null
}

variable "http_scale_rule" {
  type = object({
    name                = string
    concurrent_requests = number
  })

  default = null
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