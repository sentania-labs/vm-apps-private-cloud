# Catalog publishing is a self-service concern: each self-service project
# gets a catalog source over its released blueprints plus a project-scoped
# sharing policy (members/admins), letting project users publish catalog
# items without Service Broker Administrator access. Projects flagged
# global_catalog additionally share their source org-wide (standard
# offerings from the content-development project). IaC projects consume
# the API directly and can adopt sentania-labs/contentsharing/vra in
# their own repos if they want catalog publishing.
module "selfservice_catalog" {
  source  = "sentania-labs/contentsharing/vra"
  version = "0.1.0"

  for_each = local.selfservice_projects

  project_id          = each.value.project_id
  catalog_source_name = "${var.projects[each.key].project_name} Catalog"

  sharing_policies = merge(
    { project = {} },
    var.projects[each.key].global_catalog ? {
      organization = {
        scope               = "organization"
        share_with_everyone = true
      }
    } : {}
  )
}
