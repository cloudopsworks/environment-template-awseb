##
# (c) 2021 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
variable "namespace" {
  type        = string
  description = "Namespace identifying this environment setup"
}

variable "default_bucket_prefix" {
  type        = string
  description = "Default Bucket Prefix"
}

variable "repository_owner" {
  type        = string
  description = "(required) Repository onwer/team"
}

variable "logs_expiration_days" {
  type        = number
  description = "(required) Log bucket expiration time policy"
}

variable "logs_archive_days" {
  type        = number
  description = "(required) Log bucket file archiving to GLACIER time policy"
}

variable "versions_expiration_days" {
  type        = number
  description = "(required) Versions bucket artifact versions deletion policy"
}

variable "artifact_expiration_days" {
  type        = number
  description = "(required) Versions bucket last artifact available deletion policy"
}