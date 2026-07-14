vcfa_url          = "https://vcf-lab-automation.int.sentania.net"
vcfa_organization = "vcf-lab-vm-apps"
nsx_accounts = {
  nsx-wld02 = {
    name     = "vcf-lab-nsxmgr-wld02"
    hostname = "vcf-lab-nsxmgr-wld02.int.sentania.net"
    capability_tags = [
      {
        key   = "cloud",
        value = "vsphere"
      }
    ]
  }
}
vsphere_accounts = {
  vcf-lab-wld02 = {
    name                = "vcf-lab-wld02"
    hostname            = "vcf-lab-vcenter-wld02.int.sentania.net"
    description         = "vcf-lab-wld02-DC"
    enabled_datacenters = ["vcf-lab-wld02-dc01"]
    nsx_manager         = "vcf-lab-nsxmgr-wld02"
    capability_tags = [
      {
        key   = "cloud",
        value = "vsphere"
      },
      {
        key   = "availabilityZone",
        value = "az1"
      }
    ]
    image_mappings = [
      {
        image_name    = "ubuntu22",
        template_name = "vcf-lab-wld02-contentlibrary / ubuntu22", //when referencing a content library you must preceed the template name with it
        cloud_config  = ""
      },
      {
        image_name    = "ubuntu24",
        template_name = "vcf-lab-wld02-contentlibrary / ubuntu24", //when referencing a content library you must preceed the template name with it
        cloud_config  = ""
      }
    ]
  }
}
projects = {
  development_project = {
    project_name     = "vcf-lab-development"
    description      = "This is a project created with TF - Do Not Edit"
    basename         = "vra-dev-$${####}"
    infra_tag        = "development"
    placement_policy = "SPREAD"
    roles = {
      administrators = [
        {
          email = "vcf@int.sentania.net"
          type  = "USER"
        },
        {
          email = "labAdmins@int.sentania.net"
          type  = "GROUP"
        }
      ]
    }
  }
  test_project = {
    project_name     = "vcf-lab-test"
    description      = "This is a project created with TF - Do Not Edit"
    basename         = "vra-tst-$${####}"
    infra_tag        = "test"
    placement_policy = "SPREAD"
    roles = {
      administrators = [
        {
          email = "vcf@int.sentania.net"
          type  = "USER"
        },
        {
          email = "labAdmins@int.sentania.net"
          type  = "GROUP"
        }
      ]
    }
  }
  production_project = {
    project_name     = "vcf-lab-production"
    description      = "This is a project created with TF - Do Not Edit"
    basename         = "vra-prd-$${####}"
    infra_tag        = "production"
    placement_policy = "SPREAD"
    roles = {
      administrators = [
        {
          email = "vcf@int.sentania.net"
          type  = "USER"
        },
        {
          email = "labAdmins@int.sentania.net"
          type  = "GROUP"
        }
      ]
    }
  }
  selfservice_project = {
    project_name     = "vcf-lab-self-service"
    description      = "This is a project created with TF - Do Not Edit"
    basename         = "vra-ss-$${####}"
    iac_project      = false
    placement_policy = "SPREAD"
    roles = {
      administrators = [
        {
          email = "vcf@int.sentania.net"
          type  = "USER"
        },
        {
          email = "labAdmins@int.sentania.net"
          type  = "GROUP"
        }
      ]
    }
  }
}
