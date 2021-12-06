locals {
  default_solution = "java"
  solutions = tomap({
    java   = "64bit Amazon Linux 2 v3.2.2 running Corretto 8"
    java11 = "64bit Amazon Linux 2 v3.2.2 running Corretto 11"
    node   = "64bit Amazon Linux 2 v5.4.2 running Node.js 12"
    node14 = "64bit Amazon Linux 2 v5.4.2 running Node.js 14"
    go     = "64bit Amazon Linux 2 v3.3.2 running Go 1"
    docker = "64bit Amazon Linux 2 v3.4.2 running Docker"
  })
}
data "aws_elastic_beanstalk_application" "application" {
  name = var.application_name
}

resource "aws_elastic_beanstalk_environment" "env" {
  name                = var.release_name
  application         = data.aws_elastic_beanstalk_application.application.name
  tier                = "WebServer"
  solution_stack_name = lookup(local.solutions, var.solution_stack, local.default_solution)
  version_label       = aws_elastic_beanstalk_application_version.app_version.name
}

resource "aws_elastic_beanstalk_application_version" "app_version" {
  name         = "${var.source_name}-${var.source_version}-${var.environment}"
  application  = aws_elastic_beanstalk_environment.env.name
  description  = "Application ${var.source_name} v${var.source_version} for ${var.environment} Environment"
  force_delete = false
  bucket       = data.aws_s3_bucket.default.id
  key          = data.aws_s3_bucket_object.default.id
}

data "aws_s3_bucket" "default" {
  bucket = "${var.application_name}-${var.environment}"
}

data "aws_s3_bucket_object" "default" {
  bucket = data.aws_s3_bucket.default.id
  key = "${var.source_version}/${var.source_release}-${var.source_version}.zip"
}