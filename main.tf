provider "aws" {
  region = var.region

  assume_role {
    role_arn     = var.sts_assume_role
    session_name = "Terraform_ENV"
    external_id  = "GitHubAction"
  }
}