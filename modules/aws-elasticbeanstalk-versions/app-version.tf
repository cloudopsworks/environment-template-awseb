##
# (c) 2021 - CloudopsWorks OÜ - https://docs.cloudops.works/
#
locals {
  bucket_path     = "${var.release_name}/${var.source_version}/${var.source_name}-${var.source_version}-${var.namespace}.zip"
  config_file_sha = sha1(join("", [for f in fileset(".", "${path.root}/values/${var.release_name}/**") : filesha1(f)]))
}

resource "aws_elastic_beanstalk_application_version" "app_version" {
  depends_on = [
    null_resource.awscli_program
    #data.external.awscli_program
  ]
  name         = "${var.source_name}-${var.source_version}-${var.namespace}-${upper(substr(config_file_sha, 0, 10))}"
  application  = data.aws_elastic_beanstalk_application.application.name
  description  = "Application ${var.source_name} v${var.source_version} for ${var.namespace} Environment"
  force_delete = false
  bucket       = data.aws_s3_bucket.version_bucket.id
  key          = local.bucket_path
}

data "aws_s3_bucket" "version_bucket" {
  bucket = var.application_versions_bucket
}

resource "null_resource" "build_package" {
  depends_on = [
    null_resource.release_download_zip,
    null_resource.release_download_java,
    null_resource.release_conf_copy_node,
    null_resource.release_conf_copy
  ]
  triggers = {
    dir_sha1 = local.config_file_sha
    version  = var.source_version
    #always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command     = "zip -rqy ../target/package.zip ."
    working_dir = "${path.root}/.work/${var.release_name}/build"
  }
}

resource "null_resource" "release_pre" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "mkdir -p ${path.root}/.work/${var.release_name}/build/"
  }

  provisioner "local-exec" {
    command = "mkdir -p ${path.root}/.work/${var.release_name}/target/"
  }
}

resource "null_resource" "release_conf_copy" {
  depends_on = [
    null_resource.release_pre,
    null_resource.release_download_java,
    null_resource.release_download_zip
  ]

  triggers = {
    dir_sha1 = local.config_file_sha
    version  = var.source_version
    #always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "cp -pr ${path.root}/values/${var.release_name}/* ${path.root}/.work/${var.release_name}/build/"
  }

  # EB extensions
  provisioner "local-exec" {
    command = "cp -pr ${path.root}/values/${var.release_name}/.ebextensions ${path.root}/.work/${var.release_name}/build/"
  }

  # EB platform
  provisioner "local-exec" {
    command = "cp -pr ${path.root}/values/${var.release_name}/.platform ${path.root}/.work/${var.release_name}/build/"
  }


  provisioner "local-exec" {
    command = "echo \"Release: ${var.source_name} v${var.source_version} - Environment: ${var.release_name} / ${var.namespace}\" > .work/${var.release_name}/build/VERSION"
  }
}

resource "null_resource" "release_conf_copy_node" {
  depends_on = [
    null_resource.release_pre,
    null_resource.release_download_zip
  ]
  count = substr(var.solution_stack, 0, 4) == "node" ? 1 : 0

  triggers = {
    dir_sha1 = local.config_file_sha
    version  = var.source_version
  }

  provisioner "local-exec" {
    command = "cp -pr ${path.root}/values/${var.release_name}/.env ${path.root}/.work/${var.release_name}/build/"
  }
}
resource "null_resource" "release_download_java" {
  count = substr(var.solution_stack, 0, 4) == "java" ? 1 : 0
  depends_on = [
    null_resource.release_pre
  ]

  triggers = {
    dir_sha1 = local.config_file_sha
    version  = var.source_version
    #always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/github-asset.sh ${var.repository_owner} ${var.source_name} v${var.source_version} ${var.source_name}-${var.source_version}.jar .work/${var.release_name}/build/app.jar"
  }
}

resource "null_resource" "release_download_zip" {
  count = substr(var.solution_stack, 0, 4) != "java" ? 1 : 0
  depends_on = [
    null_resource.release_pre
  ]

  triggers = {
    dir_sha1 = local.config_file_sha
    version  = var.source_version
    #always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/github-asset.sh ${var.repository_owner} ${var.source_name} v${var.source_version} ${var.source_name}-${var.source_version}.zip ${path.root}/.work/${var.release_name}/build/source-app.zip"
  }

  provisioner "local-exec" {
    command     = "unzip -qoK source-app.zip"
    working_dir = "${path.root}/.work/${var.release_name}/build/"
  }

  provisioner "local-exec" {
    command     = "rm -f source-app.zip"
    working_dir = "${path.root}/.work/${var.release_name}/build/"
  }
}