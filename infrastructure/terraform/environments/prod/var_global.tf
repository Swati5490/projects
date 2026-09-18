variable "region" {
  description = "Azure region where the Resource Group will be created"
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, test, prod"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to the Resource Group"
  type        = map(string)
  default     = {}
}
