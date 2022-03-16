##
# (c) 2021 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
provider "aws" {
  region = var.region

  assume_role {
    role_arn     = var.sts_assume_role
    session_name = "Terraform_ENV"
    external_id  = "GitHubAction"
  }
}