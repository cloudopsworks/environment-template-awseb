##
# (c) 2021 - CloudopsWorks OÜ - https://docs.cloudops.works/
#
provider "aws" {
  region = var.region

  assume_role {
    role_arn     = var.sts_assume_role
    session_name = "Terraform-ENV-Module"
    external_id  = "GitHubActionModule"
  }
}