locals {
  projects_expanded = {
    for k, v in var.projects :
    k => {
      project_id = module.projects[k].project.id
      infra_tag  = v.infra_tag
    }
  }
}

module "simpleIACblueprint" {
  source  = "sentania-labs/vmapps-blueprint/vra"
  version = "0.2.0"

  for_each = local.projects_expanded

  projectid      = each.value.project_id
  blueprint_name = "Simple IAC Blueprint"

  content = templatefile("${path.module}/blueprint_templates/simpleIac.tpl.yaml", {
    infra_tag = each.value.infra_tag
  })
}
