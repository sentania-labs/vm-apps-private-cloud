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
    enabled_datacenters = ["vcf-lab-wld02-dc01", "vcf-lab-wld02-dc02"]
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
        template_name = "vcf-lab-wld02 / ubuntu22", //when referencing a content library you must preceed the template name with it
        cloud_config  = ""
      },
      {
        image_name    = "ubuntu24",
        template_name = "vcf-lab-wld02 / ubuntu24", //when referencing a content library you must preceed the template name with it
        cloud_config  = ""
      }
    ]
  }
}

projects = {
  sandbox_project = {
    project_name     = "vcf-lab-sandbox"
    description      = "This is a project created with TF - Do Not Edit"
    basename         = "vra-sandbox-$${####}"
    infra_tag        = "sandbox"
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
  finance_project = {
    project_name     = "vcf-lab-finance"
    description      = "This is a project created with TF - Do Not Edit"
    basename         = "vra-fnc-$${####}"
    infra_tag        = "finance"
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

  grand_rounds = {
    project_name     = "vcf-lab-grand-rounds"
    description      = "This is a project created with TF - Do Not Edit"
    basename         = "vra-hr-$${####}"
    infra_tag        = "hr"
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
  hr_project = {
    project_name     = "vcf-lab-human-resources"
    description      = "This is a project created with TF - Do Not Edit"
    basename         = "vra-hr-$${####}"
    infra_tag        = "hr"
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
