terraform {
  required_version = ">= 1.14.0"
  required_providers {
    vra = {
      source  = "vmware/vra"
      version = ">= 0.16.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 4.20.0, < 6.0.0"
    }
  }
}
