##
# (c) 2021 - CloudopsWorks OÜ - https://docs.cloudops.works/
#
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "sts_assume_role" {
  type = string
}