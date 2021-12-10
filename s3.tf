locals {
  load_balancer_log_bucket    = "${var.default_bucket_prefix}-lb-logs"
  application_versions_bucket = "${var.default_bucket_prefix}-app-versions"
}
module "versions_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                  = local.application_versions_bucket
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        #kms_master_key_id = ""
        sse_algorithm = "aws:kms"
      }
    }
  }

  lifecycle_rule = [
    {
      id      = "versions-clean"
      enabled = true

      noncurrent_version_expiration = {
        days = var.versions_expiration_days
      }

      expiration = {
        days = var.artifact_expiration_days
      }
    }
  ]
}

module "logs_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                         = local.load_balancer_log_bucket
  acl                            = "log-delivery-write"
  block_public_acls              = true
  block_public_policy            = true
  ignore_public_acls             = true
  restrict_public_buckets        = true
  force_destroy                  = true
  attach_elb_log_delivery_policy = true # Required for ALB logs
  attach_lb_log_delivery_policy  = true # Required for ALB/NLB logs

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        #kms_master_key_id = ""
        sse_algorithm = "aws:kms"
      }
    }
  }

  lifecycle_rule = [
    {
      id      = "logs-policy"
      enabled = true

      transition = [
        {
          days          = var.logs_archive_days
          storage_class = "GLACIER"
        }
      ]
      expiration = {
        days = var.logs_expiration_days
      }
    }
  ]
}