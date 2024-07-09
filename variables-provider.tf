##
# (c) 2021-2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "sts_assume_role" {
  type = string
}