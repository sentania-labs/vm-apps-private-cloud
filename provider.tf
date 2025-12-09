provider "vra" {
  url           = var.vcfa_url
  organization  = var.vcfa_organization
  refresh_token = var.vcfa_refresh_token
  insecure      = var.insecure
}
