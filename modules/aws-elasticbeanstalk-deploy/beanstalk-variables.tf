##
# (c) 2021 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
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
  default = "ELBSecurityPolicy-2016-08"
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
  type        = string
  default     = ""
  description = "(optional) Fix AMI which elasticbeanstalk is based on"
}

variable "beanstalk_instance_port" {
  type        = number
  default     = 80
  description = "(optional) Elastic Beanstalk default port for NGINX instance to run"
}

variable "beanstalk_instance_profile" {
  type        = string
  default     = "aws-elasticbeanstalk-ec2-role"
  description = "(optional) AWS instance profile role for the instance, this one must exist previous creation of instance."
}
variable "beanstalk_service_role" {
  type        = string
  default     = "aws-elasticbeanstalk-service-role"
  description = "(optional) AWS instance service role for the instance, only name instead of ARN (it is calculated), this one must exist previous creation of instance."
}

variable "port_mappings" {
  type = list(object({
    name               = string,
    from_port          = number,
    to_port            = number,
    protocol           = optional(string)
    backend_protocol   = optional(string)
    health_http_status = optional(string)
    stickiness_cookie  = optional(string)
  }))
  default = [
    {
      name      = "default"
      from_port = 80
      to_port   = 8080
    }
  ]
  description = "(optional) Mappings of Load balancer ports."
}

variable "beanstalk_enable_spot" {
  type    = bool
  default = false
}
variable "beanstalk_spot_price" {
  type        = string
  default     = ""
  description = "(optional) Spot Max price in case of enabling Spot Instances. Default is blank."
}

variable "beanstalk_spot_base_ondemand" {
  type        = number
  default     = 0
  description = "(optional) SpotFleet base on-demand instance count before provisioning Spot. Default is 0."
}

variable "beanstalk_spot_base_ondemand_percent" {
  type        = number
  default     = 0
  description = "(optional) SpotFleet base on-demand instance percent. Default is 0."
}

variable "beanstalk_min_instances" {
  type        = number
  default     = 1
  description = "(optional) Minimum number of instances on the scaling group to be allowed. Default = 1."
}
variable "beanstalk_max_instances" {
  type        = number
  default     = 1
  description = "(optional) Maximum number of instances on the scaling group to be allowed. Default = 1."
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
