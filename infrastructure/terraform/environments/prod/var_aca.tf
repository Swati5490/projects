variable "container_apps" {
  type = map(object({
    name               = string
    container_name     = string
    resource_group_key = string
    environment        = string

    image = string

    cpu    = optional(number, 0.5)
    memory = optional(string, "1Gi")

    revision_mode = optional(string, "Single")

    min_replicas = optional(number, 1)
    max_replicas = optional(number, 2)

    environment_variables = optional(map(string), {})

    ingress = optional(object({
      external_enabled           = bool
      target_port                = number
      transport                  = optional(string, "auto")
      allow_insecure_connections = optional(bool, false)
    }), null)

    http_scale_rule = optional(object({
      name                = string
      concurrent_requests = number
    }), null)

    create = bool
  }))

  default = {}
}