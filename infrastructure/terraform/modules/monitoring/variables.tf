# Monitoring Module - variables.tf

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "region" {
  description = "Azure region"
  type        = string
}

variable "resource_groups" {
  description = "Resource groups map"
  type        = map(any)
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
