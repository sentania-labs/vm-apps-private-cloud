########################################
# General VCF-A Configuration
########################################

/**
 * vcfa_url
 * URL of the VCF-A (Aria Automation) endpoint.
 */
variable "vcfa_url" {
  type = string
}

variable "vcfa_organization" {
  type        = string
  description = "The VCFA Organization"
}

/**
 * vcfa_refresh_token
 * Refresh token used for authentication to the VCF-A API.
 * Marked sensitive to avoid logging/output exposure.
 */
variable "vcfa_refresh_token" {
  type      = string
  sensitive = true
}

/**
 * insecure
 * Whether to skip SSL certificate verification when connecting
 * to the VCF-A API (typically true for lab environments).
 */
variable "insecure" {
  type    = bool
  default = true
}

/**
 * serviceAccountUserName
 * Username for the VCF-A service account.
 */
variable "serviceAccountUserName" {
  type = string
}

/**
 * serviceAccountPassword
 * Service account password (sensitive).
 */
variable "serviceAccountPassword" {
  type      = string
  sensitive = true
}

variable "github_access_token" {
  type      = string
  sensitive = true
}

########################################
# NSX Cloud Accounts
########################################

/**
 * nsx_accounts
 *
 * A map of NSX cloud account definitions.
 *
 * Structure:
 *   nsx_accounts = {
 *     key = {
 *       name            = string
 *       hostname        = string
 *       capability_tags = [
 *         {
 *           key   = string
 *           value = string
 *         }
 *       ]
 *     }
 *   }
 */
variable "nsx_accounts" {
  description = "Map of NSX cloud account definitions."
  type = map(object({
    name     = string
    hostname = string

    capability_tags = list(object({
      key   = string
      value = string
    }))
  }))
}


########################################
# vSphere Cloud Accounts
########################################

/**
 * vsphere_accounts
 *
 * A map of vSphere cloud account definitions.
 *
 * Structure:
 *   vsphere_accounts = {
 *     key = {
 *       name                = string
 *       hostname            = string
 *       description         = string
 *       enabled_datacenters = list(string)
 *       nsx_manager          = string
 *       capability_tags     = [...]
 *       image_mappings      = [
 *         {
 *           image_name    = string
 *           template_name = string
 *           cloud_config  = string
 *         }
 *       ]
 *     }
 *   }
 */
variable "vsphere_accounts" {
  description = "Map of vSphere cloud account definitions."
  type = map(object({
    name                = string
    hostname            = string
    description         = string
    enabled_datacenters = list(string)
    nsx_manager         = string

    capability_tags = list(object({
      key   = string
      value = string
    }))

    image_mappings = list(object({
      image_name    = string
      template_name = string
      cloud_config  = string
    }))
  }))
}


########################################
# Project Definitions
########################################

/**
 * projects
 *
 * A map of project configurations.
 *
 * Structure:
 *   projects = {
 *     key = {
 *       name           = string
 *       description    = string
 *       basename       = string
 *       administrators = list(string)
 *       infra_tag      = string
 *     }
 *   }
 */
variable "projects" {
  description = "Map of project definitions."
  type = map(object({
    name           = string
    description    = string
    basename       = string
    administrators = list(string)
    infra_tag      = string
  }))
}
