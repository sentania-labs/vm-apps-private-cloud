# State lives on the lab S3 (versitygw on the Synology) over HTTPS since
# 2026-09-28; before that it was the AWS bucket sentania-labs-terraform-state
# (same key). The skip_* settings are what an S3-compatible, non-AWS endpoint
# needs; locking is the S3 lock file. Not encrypted at rest (lab decision,
# 2026-09-28). Rollback of a bad state write: the Synology's hourly share snapshots.
terraform {
  backend "s3" {
    bucket                      = "tfstate"
    key                         = "vra/vm-apps-private-cloud/lab/terraform.tfstate"
    region                      = "us-east-1"
    endpoints                   = { s3 = "https://s3.int.sentania.net:9443" }
    use_path_style              = true
    use_lockfile                = true
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
  }
}
