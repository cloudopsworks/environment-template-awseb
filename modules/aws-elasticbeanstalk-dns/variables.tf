##
# (c) 2021 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
variable "release_name" {
  type = string
}

variable "namespace" {
  type        = string
  description = "(required) namespace that determines the environment naming"
}

variable "beanstalk_environment_cname" {
  type        = string
  description = "(required) CNAME to point records to."
}