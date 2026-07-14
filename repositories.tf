module "repository" {
  source  = "mineiros-io/repository/github"
  version = "0.18.0"

  for_each = { for k, m in module.projects : k => m if var.projects[k].iac_project }

  name       = each.value.project.name
  visibility = "public"
  template = {
    owner      = "sentania-labs"
    repository = "vcf-lab-application-template"
  }
  archive_on_destroy = false
  plaintext_secrets = {
    VCFA_PROJECT_NAME      = replace(each.value.project.name, " ", "_")
    VCFA_PROJECT_ID        = each.value.project.id
    VCFA_ORGANIZATION_NAME = var.vcfa_organization
  }
}