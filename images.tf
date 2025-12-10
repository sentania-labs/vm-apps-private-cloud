module "image_mappings" {
  source     = "sentania-labs/image-profile/vra"
  version    = "0.1.0"
  depends_on = [time_sleep.wait_cloud_account_creation]
  for_each = {
    for r in local.cloud_account_regions :
    "${r.region_name}-image_mapping" => r
  }
  cloud_account_id   = each.value.cloud_account_id
  image_profile_name = "${each.value.region_name}-mapping"
  image_description  = "Lab Image Profile managed by TF"
  image_mappings     = each.value.image_mappings
  region             = each.value.region_id
}
