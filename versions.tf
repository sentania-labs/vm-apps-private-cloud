terraform {
  required_version = ">= 1.1.9"
  required_providers {
    vra = {
      source  = "vmware/vra"
      version = ">= 0.15.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
      github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
