##
# (c) 2021 - CloudopsWorks OÜ - https://docs.cloudops.works/
#
variable "release_name" {
  type = string
}

variable "source_name" {
  type = string
}

variable "source_version" {
  type = string
}

variable "solution_stack" {
  type    = string
  default = "java"
}

variable "application_versions_bucket" {
  type        = string
  description = "(Required) Application Versions bucket"
}

variable "namespace" {
  type        = string
  description = "(required) namespace that determines the environment naming"
}

variable "repository_url" {
  type        = string
  default     = "https://github.com"
  description = "(optional) repository url to pull releases."
}

variable "repository_owner" {
  type        = string
  description = "(required) Repository onwer/team"
}

variable "extra_files" {
  type        = list(string)
  default     = []
  description = "(optional) List of source files where to pull info"
}