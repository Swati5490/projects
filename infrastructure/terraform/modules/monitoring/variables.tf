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

variable "log_analytics_workspaces" {
  type    = map(any)
  default = {}
}

variable "app_insights" {
  type    = map(any)
  default = {}
}

variable "action_groups" {
  type    = map(any)
  default = {}
}

variable "diagnostic_settings" {
  type    = map(any)
  default = {}
}

variable "metric_alert_rules" {
  type    = map(any)
  default = {}
}
