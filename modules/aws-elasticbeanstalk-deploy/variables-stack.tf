##
# (c) 2021 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "solution_stack" {
  type        = string
  default     = "java"
  description = <<EOL
(required) Specify solution stack for Elastic Beanstalk
Solution stack is one of:
  java      = \"^64bit Amazon Linux 2 (.*) running Corretto 8(.*)$\"
  java11    = \"^64bit Amazon Linux 2 (.*) running Corretto 11(.*)$\"
  tomcatj8  = \"^64bit Amazon Linux 2 (.*) Tomcat (.*) Corretto 8(.*)$\"
  tomcatj11 = \"^64bit Amazon Linux 2 (.*) Tomcat (.*) Corretto 11(.*)$\"
  node      = \"^64bit Amazon Linux 2 (.*) Node.js 12(.*)$\"
  node14    = \"^64bit Amazon Linux 2 (.*) Node.js 14(.*)$\"
  go        = \"^64bit Amazon Linux 2 (.*) running Go (.*)$\"
  docker    = \"^64bit Amazon Linux 2 (.*) running Docker (.*)$\"
  docker-m  = \"^64bit Amazon Linux 2 (.*) Multi-container Docker (.*)$\"
  java-amz1 = \"^64bit Amazon Linux (.*)$ running Java 8(.*)$\"
  node-amz1 = \"^64bit Amazon Linux (.*)$ running Node.js(.*)$\"
EOL
}
