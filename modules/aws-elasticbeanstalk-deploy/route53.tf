##
# (c) 2021 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
data "aws_route53_zone" "app_domain" {
  count = var.domain_name_alias_prefix != "" ? 1 : 0

  name = var.domain_name
}

resource "aws_route53_record" "app_record" {
  count = var.domain_name_alias_prefix != "" ? 1 : 0

  zone_id = data.aws_route53_zone.app_domain.0.id
  name    = "${var.domain_name_alias_prefix}.${var.domain_name}"
  type    = "CNAME"
  ttl     = var.default_domain_ttl
  records = [
    aws_elastic_beanstalk_environment.beanstalk_environment.cname
  ]
}