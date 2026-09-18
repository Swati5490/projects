variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "region" {
  description = "Azure deployment region"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}