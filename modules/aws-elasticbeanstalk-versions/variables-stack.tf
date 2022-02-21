##
# (c) 2021 - CloudopsWorks OÜ - https://docs.cloudops.works/
#

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
