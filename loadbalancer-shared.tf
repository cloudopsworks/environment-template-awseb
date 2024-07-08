##
# (c) 2023 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
# Module to manage the association of the DNS record with the shared load balancer

data "aws_lb" "shared_lb" {
  for_each = {
    for k, v in local.configurations : k => v
    if try(v.beanstalk.load_balancer.shared.enabled, false)
  }
  name = each.value.beanstalk.load_balancer.shared.name
}

module "app_dns_shared" {
  for_each = {
    for k, v in local.configurations : k => v
    if try(v.beanstalk.load_balancer.shared.enabled, false) && try(v.beanstalk.load_balancer.shared.dns.enabled, false)
  }

  source          = "cloudopsworks/beanstalk-dns/aws"
  version         = "1.0.5"
  region          = var.region
  sts_assume_role = var.sts_assume_role

  release_name             = each.value.release.name
  namespace                = var.namespace
  private_domain           = try(each.value.dns.private_zone, false)
  domain_name              = each.value.dns.domain_name
  domain_name_alias_prefix = each.value.dns.alias_prefix
  domain_alias             = true
  alias_cname              = data.aws_lb.shared_lb[each.key].dns_name
  alias_zone_id            = data.aws_lb.shared_lb[each.key].zone_id
  #health_check_id          = try(aws_route53_health_check.health_a[0].id, "")
}