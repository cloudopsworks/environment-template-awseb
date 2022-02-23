##
# (c) 2021 - CloudopsWorks OÜ - https://docs.cloudops.works/
#
locals {
  default_solution = "java"
  solutions = {
    java      = "^64bit Amazon Linux 2 (.*) running Corretto 8(.*)$"
    java11    = "^64bit Amazon Linux 2 (.*) running Corretto 11(.*)$"
    tomcatj8  = "^64bit Amazon Linux 2 (.*) Tomcat (.*) Corretto 8(.*)$"
    tomcatj11 = "^64bit Amazon Linux 2 (.*) Tomcat (.*) Corretto 11(.*)$"
    node      = "^64bit Amazon Linux 2 (.*) Node.js 12(.*)$"
    node14    = "^64bit Amazon Linux 2 (.*) Node.js 14(.*)$"
    go        = "^64bit Amazon Linux 2 (.*) running Go (.*)$"
    docker    = "^64bit Amazon Linux 2 (.*) running Docker (.*)$"
    docker-m  = "^64bit Amazon Linux 2 (.*) Multi-container Docker (.*)$"
    java-amz1 = "^64bit Amazon Linux (.*)$ running Java 8(.*)$"
    node-amz1 = "^64bit Amazon Linux (.*)$ running Node.js(.*)$"
  }

}

data "aws_elastic_beanstalk_solution_stack" "solution_stack" {
  most_recent = true

  name_regex = lookup(local.solutions, var.solution_stack, local.default_solution)
}

resource "aws_elastic_beanstalk_environment" "beanstalk_environment" {
  name                = var.beanstalk_environment != "" ? var.beanstalk_environment : "${var.release_name}-${var.namespace}"
  application         = data.aws_elastic_beanstalk_application.application.name
  cname_prefix        = var.load_balancer_alias != "" ? var.load_balancer_alias : "${var.release_name}-${var.namespace}-ingress"
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.solution_stack.name
  tier                = "WebServer"
  version_label       = var.application_version_label

  dynamic "setting" {
    for_each = local.eb_settings
    content {
      name      = setting.value["name"]
      namespace = setting.value["namespace"]
      resource  = setting.value["resource"]
      value     = setting.value["value"]
    }
  }
}
