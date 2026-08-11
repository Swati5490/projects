output "front_door_id" {
  description = "Front Door ID"
  value       = try(azurerm_cdn_frontdoor_profile.main[0].id, null)
}

output "front_door_name" {
  description = "Front Door name"
  value       = try(azurerm_cdn_frontdoor_profile.main[0].name, null)
}

output "front_door_endpoint" {
  description = "Front Door endpoint"
  value       = try("${azurerm_cdn_frontdoor_profile.main[0].name}.azureedge.net", null)
}

output "custom_domains" {
  description = "Custom domains"
  value = try({
    for domain in azurerm_cdn_frontdoor_custom_domain.main :
    domain.name => domain.host_name
  }, {})
}

output "origin_groups" {
  description = "Origin groups"
  value = try({
    for group in azurerm_cdn_frontdoor_origin_group.main :
    group.name => group.id
  }, {})
}

output "waf_policy_id" {
  description = "WAF Policy ID"
  value       = try(azurerm_cdn_frontdoor_firewall_policy.main[0].id, null)
}
