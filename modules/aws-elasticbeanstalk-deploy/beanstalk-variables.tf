##
# (c) 2021 - CloudopsWorks OÜ - https://docs.cloudops.works/
#
variable "private_subnets" {
  type    = list(string)
  default = []
}

variable "public_subnets" {
  type    = list(string)
  default = []
}

variable "vpc_id" {
  type = string
}


variable "server_types" {
  type    = list(string)
  default = ["t3a.micro"]
}

variable "load_balancer_alias" {
  type    = string
  default = ""
}

variable "place_on_public" {
  type    = bool
  default = false
}

variable "load_balancer_log_prefix" {
  type = string
}

variable "load_balancer_log_bucket" {
  type = string
}

variable "load_balancer_ssl_certificate_id" {
  type = string
}

variable "load_balancer_public" {
  type        = bool
  default     = false
  description = "(optional) specify if load balancer will be public or private, by default is private"
}

variable "load_balancer_ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}

variable "domain_name" {
  type    = string
  default = "4wrd.tech"
}

variable "domain_name_alias_prefix" {
  type = string
}

variable "beanstalk_application" {
  type = string
}

variable "beanstalk_environment" {
  type    = string
  default = ""
}
variable "beanstalk_ec2_key" {
  type = string
}

variable "beanstalk_ami_id" {
  type = string
}

variable "beanstalk_instance_port" {
  type    = number
  default = 8081
}

variable "beanstalk_backend_app_port" {
  type    = number
  default = 8080
}

variable "beanstalk_enable_spot" {
  type    = bool
  default = false
}

variable "beanstalk_default_retention" {
  type    = number
  default = 7
}

variable "beanstalk_instance_volume_size" {
  type    = number
  default = 8
}

variable "beanstalk_instance_volume_type" {
  type    = string
  default = "gp2"
}
