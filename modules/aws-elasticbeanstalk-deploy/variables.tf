##
# (c) 2021 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
variable "release_name" {
  type = string
}

# variable "source_name" {
#   type = string
# }

# variable "source_version" {
#   type = string
# }

# variable "application_versions_bucket" {
#   type        = string
#   description = "(Required) Application Versions bucket"
# }

variable "namespace" {
  type        = string
  description = "(required) namespace that determines the environment naming"
}

variable "extra_files" {
  type        = list(string)
  default     = []
  description = "(optional) List of source files where to pull info."
}

variable "application_version_label" {
  type        = string
  description = "(required) Application version label to apply to environment"
}