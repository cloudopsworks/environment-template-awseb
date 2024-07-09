##
# (c) 2021-2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
variable "organization_name" {
  type        = string
  description = "Organization Name"

}
variable "environment_name" {
  type        = string
  description = "Environment Name"

}
variable "namespace" {
  type        = string
  description = "Namespace identifying this environment setup"
}

variable "default_bucket_prefix" {
  type        = string
  description = "Default Bucket Prefix"
}

variable "random_bucket_suffix" {
  type        = bool
  default     = false
  description = "Random Suffix"
}

variable "repository_owner" {
  type        = string
  description = "(required) Repository onwer/team"
}

variable "logs_retention_years" {
  type        = number
  description = "(required) Log bucket expiration time policy in years."
  default     = 3
}

variable "logs_archive_days" {
  type        = number
  description = "(required) Log bucket file archiving to GLACIER time policy"
}

variable "versions_retention_years" {
  type        = number
  description = "(required) Versions bucket artifact versions deletion policy"
  default     = 3
}

variable "artifact_retention_years" {
  type        = number
  description = "(required) Versions bucket last artifact available deletion policy"
  default     = 3
}

variable "artifact_transition_days" {
  type        = number
  description = "(required) Versions bucket transition to different tiers Day 0 -> Standard-IA -> Glacier in days."
}

variable "artifact_archive_days" {
  type        = number
  description = "(required) Transition to archive storage tier Standard-IA -> Glacier in days."
  default     = 365
}

variable "versions_archive_days" {
  type        = number
  description = "(required) Transition to archive storage tier Standard-IA -> Glacier in days."
  default     = 365
}