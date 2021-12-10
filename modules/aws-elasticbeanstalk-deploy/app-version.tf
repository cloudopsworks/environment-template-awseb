##
# (c) 2021 - CloudopsWorks OÜ - https://docs.cloudops.works/
#
locals {
  bucket_path = "${var.release_name}/${var.source_version}/${var.source_name}-${var.source_version}-${var.namespace}.zip"
}


resource "aws_elastic_beanstalk_application_version" "app_version" {
  depends_on = [
    module.file_s3_upload
  ]
  name         = "${var.source_name}-${var.source_version}-${var.namespace}"
  application  = data.aws_elastic_beanstalk_application.application.name
  description  = "Application ${var.source_name} v${var.source_version} for ${var.namespace} Environment"
  force_delete = false
  bucket       = data.aws_s3_bucket.version_bucket.id
  key          = local.bucket_path
}

data "aws_s3_bucket" "version_bucket" {
  bucket = var.application_versions_bucket
}

module "file_s3_upload" {
  depends_on = [
    data.archive_file.build_package,
    null_resource.release_download_zip,
    null_resource.release_download_java
  ]

  source            = "./modules/aws-cli"
  assume_role_arn   = var.sts_assume_role
  role_session_name = "Terraform-ENV-fileupload"
  aws_cli_commands = [
    "s3",
    "cp",
    ".work/${var.release_name}/target/package.zip",
    "s3://${data.aws_s3_bucket.version_bucket.id}/${local.bucket_path}",
    "--quiet",
    "--region",
    "${var.region}"
  ]
}

data "archive_file" "build_package" {
  depends_on = [
    null_resource.release_download_zip,
    null_resource.release_download_java
  ]
  source_dir  = ".work/${var.release_name}/build/"
  output_path = ".work/${var.release_name}/target/package.zip"
  type        = "zip"
}

resource "null_resource" "release_pre" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "mkdir -p .work/${var.release_name}/build/"
  }

  provisioner "local-exec" {
    command = "mkdir -p .work/${var.release_name}/target/"
  }
}

resource "null_resource" "release_conf_copy" {
  depends_on = [
    null_resource.release_pre
  ]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "cp -pr values/${var.release_name}/* .work/${var.release_name}/build/"
  }

  provisioner "local-exec" {
    command = "cp -pr values/${var.release_name}/.eb* .work/${var.release_name}/build/"
  }
  provisioner "local-exec" {
    command = "echo \"Release: ${var.source_name} v${var.source_version} - Environment: ${var.release_name} / ${var.namespace}\" > .work/${var.release_name}/build/VERSION"
  }
}

resource "null_resource" "release_download_java" {
  count = var.solution_stack == "java" ? 1 : 0
  depends_on = [
    null_resource.release_pre
  ]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/github-asset.sh ${var.repository_owner} ${var.source_name} v${var.source_version} ${var.source_name}-${var.source_version}.jar .work/${var.release_name}/build/app.jar"
  }
}

resource "null_resource" "release_download_zip" {
  count = var.solution_stack != "java" ? 1 : 0
  depends_on = [
    null_resource.release_pre
  ]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command     = "curl -O ${var.repository_url}/${var.repository_owner}/${var.source_name}/releases/downloads/v${var.source_version}/${var.source_name}-${var.source_version}.zip"
    working_dir = ".work/${var.release_name}/build/"
  }
}