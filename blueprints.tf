locals {
  # iac_project is the project-type discriminator:
  # true  -> IaC project: pipeline repo + Simple IAC Blueprint (tier baked in via infra_tag)
  # false -> self-service project: no repo; Simple Self Service Blueprint with
  #          runtime serviceLevel selection
  projects_expanded = {
    for k, v in var.projects :
    k => {
      project_id = module.projects[k].project.id
      infra_tag  = v.infra_tag
    } if v.iac_project
  }

  selfservice_projects = {
    for k, v in var.projects :
    k => {
      project_id = module.projects[k].project.id
    } if !v.iac_project
  }
}

module "simpleIACblueprint" {
  source  = "sentania-labs/blueprint/vra"
  version = "0.9.0"

  for_each = local.projects_expanded

  projectid      = each.value.project_id
  blueprint_name = "Simple IAC Blueprint"

  content = templatefile("${path.module}/blueprint_templates/simpleIac.tpl.yaml", {
    infra_tag = each.value.infra_tag
  })
}

module "selfServiceBlueprint" {
  source  = "sentania-labs/blueprint/vra"
  version = "0.9.0"

  for_each = local.selfservice_projects

  projectid      = each.value.project_id
  blueprint_name = "Simple Self Service Blueprint"

  content = templatefile("${path.module}/blueprint_templates/simpleSelfService.tpl.yaml", {})
}
