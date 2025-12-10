module "flavor_mappings" {
  source  = "sentania-labs/flavor-profile/vra"
  version = "0.2.0"

  depends_on = [time_sleep.wait_cloud_account_creation]
  for_each   = data.vra_region.all
  name       = "${each.value.name}-flv"
  flavor_mappings = [
    {
      name      = "small",
      cpu_count = 1
      memory    = 2048
    },
    {
      name      = "medium",
      cpu_count = 2
      memory    = 4096
      }, {
      name      = "large",
      cpu_count = 4
      memory    = 6144
    }
  ]
  region_id = each.value.id

}
