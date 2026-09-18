# Compute Module - outputs.tf

output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.id
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "kube_config" {
  description = "Kubernetes config"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "kube_config_encoded" {
  description = "Base64 encoded Kubernetes config"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "fqdn" {
  description = "The FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "client_certificate" {
  description = "Base64 encoded client certificate"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
  sensitive   = true
}

output "identity" {
  description = "The identity of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

output "kubelet_identity_principal_id" {
  description = "The principal ID used by the AKS kubelet identity"
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}
