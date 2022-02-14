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
  type        = string
  default     = "java"
  description = <<EOL
(required) Specify solution stack for Elastic Beanstalk
Solution stack is one of:
  java      = \"^64bit Amazon Linux 2 (.*) Corretto 8(.*)$\"
  java11    = \"^64bit Amazon Linux 2 (.*) Corretto 11(.*)$\"
  node      = \"^64bit Amazon Linux 2 (.*) Node.js 12(.*)$\"
  node14    = \"^64bit Amazon Linux 2 (.*) Node.js 14(.*)$\"
  go        = \"^64bit Amazon Linux 2 (.*) Go (.*)$\"
  docker    = \"^64bit Amazon Linux 2 (.*) Docker (.*)$\"
  docker-m  = \"^64bit Amazon Linux 2 (.*) Multi-container Docker (.*)$\"
  java-amz1 = \"^64bit Amazon Linux (.*)$ running Java 8(.*)$\"
  node-amz1 = \"^64bit Amazon Linux (.*)$ running Node.js(.*)$\"
EOL
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