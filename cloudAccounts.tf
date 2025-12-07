####ON PREM vSphere Infrastructure
module "cloud_accounts_vsphere" {
  source  = "sentania-labs/vmapps-vspherecloudaccount/vra"
  version = "0.5.0"
  for_each = {
    for ca in var.vsphere_accounts :
    ca.name => ca
  }
  name                = each.value.name
  hostname            = each.value.hostname
  description         = each.value.description
  password            = var.serviceAccountPassword
  username            = var.serviceAccountUserName
  enabled_datacenters = each.value.enabled_datacenters
  capability_tags     = each.value.capability_tags
  nsxManager          = module.cloud_accounts_nsxt[each.value.nsxManager].cloud_account.id
}
###END vSphere

###NSX Manager
module "cloud_accounts_nsxt" {
  source  = "sentania-labs/vmapps-nsxcloudaccount/vra"
  version = "0.5.0"
  for_each = {
    for ca in var.nsx_accounts :
    ca.name => ca
  }

  name            = each.value.name
  hostname        = each.value.hostname
  password        = var.serviceAccountPassword
  username        = var.serviceAccountUserName
  capability_tags = each.value.capability_tags
}
##END NSX Manager
