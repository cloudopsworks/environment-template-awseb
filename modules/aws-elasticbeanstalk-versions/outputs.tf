output "application_version_label" {
  value = aws_elastic_beanstalk_application_version.app_version.name
}

output "application_version_path" {
  value = local.bucket_path
}