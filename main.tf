locals {
  cloud_account_regions = flatten([
    for ca_key, ca in module.cloud_accounts_vsphere : [
      for r in ca.cloud_account.enabled_regions : {
        cloud_account_name = ca_key
        cloud_account_id   = ca.cloud_account.id
        region_name        = r.name
        external_region_id = r.external_region_id
        region_id          = r.id
        image_mappings     = var.vsphere_accounts[ca_key].image_mappings
      }
    ]
  ])
}

data "vra_region" "all" {
  depends_on = [time_sleep.wait_cloud_account_creation]
  for_each = {
    for item in local.cloud_account_regions :
    "${item.region_name}" => item
  }

  cloud_account_id = each.value.cloud_account_id
  region           = each.value.external_region_id
}

//this resource allows the API to full populate and be a dependancy for cloud account data population
resource "time_sleep" "wait_cloud_account_creation" {
  depends_on = [module.cloud_accounts_vsphere]

  create_duration = "60s"
}
