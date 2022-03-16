##
# (c) 2022 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
variable "domain_name" {
  type        = string
  default     = "example.com"
  description = "(optional) Application environment Route53 managed DNS records. if `domain_name_alias_prefix` is not specified then is not queried."
}

variable "domain_name_alias_prefix" {
  type        = string
  default     = ""
  description = "(optional) Application name prefix for domain in order to form FQDN. If not specified no DNS record will be created"
}

variable "default_domain_ttl" {
  type        = number
  default     = 300
  description = "(optional) Default DNS record TTL setting. 300s"
}

variable "domain_name_weight" {
  type        = number
  default     = -1
  description = "(optional) DNS weight >=0 states weighted DNS distribution."
}