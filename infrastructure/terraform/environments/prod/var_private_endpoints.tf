variable "private_endpoints" {
  type = map(object({
    name                 = string
    resource_group       = string
    subnet_name          = string
    service_type         = string
    service_name         = string
    subresource_names    = list(string)
    create               = bool
  }))

  default = {}
}