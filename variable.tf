locals {
  aks_dns_group   = "TerraformAKSPrincipals"
  aks_admin_group = "Azure AKS Admins"
#  aks_name        = var.AKS_NAME == null ? "aks-${local.app_suffix}" : var.AKS_NAME
  aks_name        = var.AKS_NAME
  aks_dns_name    = replace(local.aks_name, "-", "")
  aks_mi_name     = replace(local.aks_name, "-", "")
  dns_zone_id     = "/subscriptions/f2a41739-c9ac-4291-b070-f2a92545c38c/resourceGroups/rg-eastus2-hub1-main/providers/Microsoft.Network/privateDnsZones/privatelink.${var.LOCATION}.azmk8s.io"
}
variable "AKS_NAME" {
  description = "Name of this aks cluster"
  type        = string
  default     = "sampleazpolicycluster"
}
variable "AKS_VERSION" {
  description = "Version for this AKS Cluster"
  type        = string
  default     = "1.20.9"
}
variable "AKS_SKU" {
  description = "AKS SKU to use. Free or Paid. Defaults to Free."
  type        = string
  default     = "Free"
}
variable "AKS_PRIVATE_CLUSTER" {
  description = "Flag to create AKS private cluster. Should always be true inside Barings Network."
  type        = bool
  default     = true
}
variable "AKS_SYS_NODE_SIZE" {
  description = "Size of the system nodes"
  type        = string
  default     = "Standard_D2s_v5"
}
variable "AKS_SYS_NODE_COUNT" {
  description = "Number of nodes in system pool"
  type        = string
  default     = "1"
}
variable "AKS_SYS_AUTO_SCALE" {
  description = "Enable auto scaling of system pool"
  type        = bool
  default     = true
}
variable "AKS_SYS_AUTO_MAX" {
  description = "Maximum number of nodes system pool can scale"
  type        = string
  default     = "6"
}
variable "AKS_SYS_AUTO_MIN" {
  description = "Minimum number of nodes system pool can scale"
  type        = string
  default     = "1"
}
variable "AKS_LB_SKU" {
  description = "Load balancer sku to use for this cluster."
  type        = string
  default     = "Standard"
}
variable "AKS_SYS_AVAILABILITY_ZONES" {
  description = "Load balancer sku to use for this cluster."
  type        = list(any)
  default     = ["1", "2", "3"]
}
variable "AKS_ENABLE_LOG_ANALYTICS_WORKSPACE_ID" {
  type        = string
  description = "Enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not"
  default     = null
}
variable "azure_policy_enabled" {
  type        = bool
  description = "Enable azure policy"
  default     = true
}
variable "LOCATION"{
  type       = string
  description = "location of resource"
  default    = "eastus2"
}
variable "RESOURCE_GROUP_NAME"{
  type  = string
  description = "resource group name"
  default = "rgshafali-azpolicy"
}
variable "aks_dns_group"{
  type   = string
  description = "azure ad dns group name"
  default = "addnsgrp"
}
