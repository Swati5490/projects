# ============================================================================
# RESOURCE GROUPS
# ============================================================================

variable "resource_groups" {
  description = "Resource Group configurations"

  type = map(object({
    name    = string
    purpose = optional(string)
    create  = bool
  }))

  default = {}
}