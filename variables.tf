##
# (c) 2021 - CloudopsWorks OÜ - https://docs.cloudops.works/
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