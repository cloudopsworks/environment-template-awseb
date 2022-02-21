##
# (c) 2021 - CloudopsWorks OÜ - https://docs.cloudops.works/
#
data "aws_elastic_beanstalk_application" "application" {
  name = var.beanstalk_application
}
