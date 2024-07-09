##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
module "tags" {
  source  = "cloudopsworks/tags/local"
  version = "1.0.9"

  env = {
    organization_name = var.organization_name
    org_unit_name     = var.repository_owner
    environment_name  = var.environment_name
    environment_type  = var.namespace
  }
}