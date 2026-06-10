vcfa_url          = "https://vcf-lab-automation.int.sentania.net"
vcfa_organization = "vcf-lab-vm-apps"
nsx_accounts = {
  nsx-wld01 = {
    name     = "vcf-lab-nsxmgr-wld01"
    hostname = "vcf-lab-nsxmgr-wld01.int.sentania.net"
    capability_tags = [
      {
        key   = "cloud",
        value = "vsphere"
      }
    ]
  }
}
vsphere_accounts = {
  vcf-lab-wld01 = {
    name                = "vcf-lab-wld01"
    hostname            = "vcf-lab-vcenter-wld01.int.sentania.net"
    description         = "vcf-lab-wld01-DC"
    enabled_datacenters = ["vcf-lab-wld01-dc01"]
    nsx_manager         = "vcf-lab-nsxmgr-wld01"
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
        template_name = "vcf-lab-wld01-contentlibrary / ubuntu22", //when referencing a content library you must preceed the template name with it
        cloud_config  = ""
      },
      {
        image_name    = "ubuntu24",
        template_name = "vcf-lab-wld01-contentlibrary / ubuntu24", //when referencing a content library you must preceed the template name with it
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
}
