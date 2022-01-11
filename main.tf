### Get some data from keyvault
#data "azurerm_key_vault_secret" "vmadminpassword" {
#  provider     = azurerm.sec
#  name         = "vm-admin-password"
#  key_vault_id = data.azurerm_key_vault.iaccentralkv.id
#}
provider "azurerm" {
  features {}
}
 
### Create a managed identity and add it to the DNS contributor group and as network contributor to subscription
resource "azurerm_user_assigned_identity" "aksuser" {
  resource_group_name = var.RESOURCE_GROUP_NAME
  location            = var.LOCATION
  name                = local.aks_mi_name
}
# data "azuread_group" "aksdns" {
#  display_name = local.aks_dns_group
#}

data "azurerm_subscription" "primary" {
}
# resource "azuread_group_member" "dnscontributor" {
#  group_object_id  = data.azuread_group.aksdns.object_id
#  member_object_id = azurerm_user_assigned_identity.aksuser.principal_id
#}
resource "azurerm_role_assignment" "networkcontrib" {
#  scope                = data.azurerm_subscription.current.id
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aksuser.principal_id
  depends_on           = [azurerm_user_assigned_identity.aksuser]
}
#resource "time_sleep" "wait_for_dns" {
#  depends_on      = [azuread_group_member.dnscontributor, azurerm_role_assignment.networkcontrib]
#  create_duration = "30s"
#}
 
### Get the AKS admins group
#data "azuread_group" "aks_cluster_admins" {
# display_name = local.aks_admin_group
# }
 
### Create the AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                       = local.aks_name
  location                   = var.LOCATION
  resource_group_name        = var.RESOURCE_GROUP_NAME
  node_resource_group        = "rg-${local.aks_name}-nodes"
  sku_tier                   = var.AKS_SKU
  private_cluster_enabled    = var.AKS_PRIVATE_CLUSTER
  private_dns_zone_id        = local.dns_zone_id
  dns_prefix_private_cluster = local.aks_dns_name
  kubernetes_version         = var.AKS_VERSION
 
  identity {
    type                      = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.aksuser.id
  }
 
  addon_profile {
    oms_agent {
      enabled                    = var.AKS_ENABLE_LOG_ANALYTICS_WORKSPACE_ID == null ? false : true
      log_analytics_workspace_id = var.AKS_ENABLE_LOG_ANALYTICS_WORKSPACE_ID
      }
      azure_policy {
      enabled = var.azure_policy_enabled
      }
  }
 
  default_node_pool {
    name                = "system"
    vm_size             = var.AKS_SYS_NODE_SIZE
    node_count          = var.AKS_SYS_NODE_COUNT
    #vnet_subnet_id      = var.PRIVATE_SUBNET_ID
    enable_auto_scaling = var.AKS_SYS_AUTO_SCALE
    max_count           = var.AKS_SYS_AUTO_MAX
    min_count           = var.AKS_SYS_AUTO_MIN
    availability_zones  = var.AKS_SYS_AVAILABILITY_ZONES
  }
 
  network_profile {
    network_plugin     = "kubenet"
    load_balancer_sku  = var.AKS_LB_SKU
    service_cidr       = "172.18.0.0/16"
    dns_service_ip     = "172.18.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    pod_cidr           = "192.168.0.0/22"
  }
 
  role_based_access_control {
    enabled = true
 #   azure_active_directory {
 #     managed                = true
  #    admin_group_object_ids = [data.azuread_group.aks_cluster_admins.id]
  #  }
  }
 
#  depends_on = [time_sleep.wait_for_dns]
  lifecycle { ignore_changes = [ tags, default_node_pool[0].node_count, ] }
}
