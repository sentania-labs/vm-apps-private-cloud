locals {
  all_cloud_zone_ids = [
    for _, m in module.cloud_zones : m.cloud_zone.id
  ]
}

module "projects" {
  source     = "sentania-labs/project/vra"
  version    = "0.6.0"
  depends_on = [time_sleep.wait_cloud_account_creation]
  for_each   = var.projects

  project_name      = each.value.project_name
  description       = each.value.description
  basename          = each.value.basename
  cloud_zone_ids    = local.all_cloud_zone_ids
  custom_properties = each.value.custom_properties
  placement_policy  = each.value.placement_policy
  constraints       = each.value.constraints

  roles = each.value.roles
}

