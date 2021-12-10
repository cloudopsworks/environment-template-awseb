resource "random_string" "awscli_output_temp_file_name" {
  keepers = {
    allways_run = "${timestamp()}"
  }
  length  = 16
  special = false
}

resource "local_file" "awscli_results_file" {
  depends_on           = [random_string.awscli_output_temp_file_name]
  filename             = "${path.module}/temp/${random_string.awscli_output_temp_file_name.result}.json"
  directory_permission = "0777"
  file_permission      = "0666"
}

locals {
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
  debug_log_filename = ""
  aws_cli_query      = ""
}

data "external" "awscli_program" {
  depends_on = [
    local_file.awscli_results_file,
    data.archive_file.build_package,
    null_resource.release_download_zip,
    null_resource.release_download_java
  ]
  program = ["${path.module}/scripts/awsWithAssumeRole.sh"]
  query = {
    assume_role_arn    = local.assume_role_arn
    role_session_name  = local.role_session_name
    aws_cli_commands   = join(" ", local.aws_cli_commands)
    aws_cli_query      = local.aws_cli_query
    output_file        = local_file.awscli_results_file.filename
    debug_log_filename = local.debug_log_filename
    aws_region         = var.region
  }
}

data "local_file" "awscli_results_file" {
  depends_on = [data.external.awscli_program]
  filename   = data.external.awscli_program.query.output_file
}