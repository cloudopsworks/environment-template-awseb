##
# (c) 2023 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
locals {
  configurations = {
    for f in fileset(path.module, "*-module.yaml") :
    basename(f) => yamldecode(file(f))
  }
  alarm_configurations = {
    for k, v in local.configurations :
    k => v
    if try(v.alarms.enabled, false)
  }
  apiqw_nlb_vpc_links = {
    for k, v in local.configurations :
    k => v
    if try(v.api_gateway.enabled, false) && try(v.api_gateway.vpc_link.use_existing, false)
  }
  apigw_nlb_configurations = {
    for k, v in local.configurations :
    k => v
    if try(v.api_gateway.enabled, false) && try(!v.api_gateway.vpc_link.use_existing, true)
  }
  tags = {
    for k, v in local.configurations :
    k => merge(v.beanstalk.extra_tags, {
      Environment = format("%s-%s", v.release.name, var.namespace)
      Namespace   = var.namespace
      Release     = v.release.name
    })
  }
}

##
# This module to manage DNS association.
#   - This can be commented out to disable DNS management (not recommended)
#
module "dns" {
  for_each = {
    for k, v in local.configurations : k => v
    if !try(v.beanstalk.load_balancer.shared.enabled, false)
  }

  source          = "cloudopsworks/beanstalk-dns/aws"
  version         = "1.0.4"
  region          = var.region
  sts_assume_role = var.sts_assume_role

  release_name             = each.value.release.name
  namespace                = var.namespace
  domain_name              = each.value.dns.domain_name
  domain_name_alias_prefix = each.value.dns.alias_prefix
  domain_alias             = true
  alias_cname              = module.app[each.key].environment_cname
  alias_zone_id            = module.app[each.key].environment_zone_id
}

module "version" {
  for_each = local.configurations

  source          = "cloudopsworks/beanstalk-version/aws"
  version         = "1.0.10"
  region          = var.region
  sts_assume_role = var.sts_assume_role

  release_name     = each.value.release.name
  source_name      = each.value.release.source.name
  source_version   = each.value.release.source.version
  namespace        = var.namespace
  solution_stack   = each.value.beanstalk.solution_stack
  repository_owner = var.repository_owner
  # Uncomment below to override the default source for the solution stack
  #   Supported source_compressed_type: zip, tar, tar.gz, tgz, tar.bz, tar.bz2, etc.
  force_source_compressed = can(each.value.release.source.force_compressed) ? each.value.release.source.force_compressed : false
  source_compressed_type  = can(each.value.release.source.compressed_type) ? each.value.release.source.compressed_type : "zip"

  application_versions_bucket = module.versions_bucket.s3_bucket_id

  beanstalk_application = each.value.beanstalk.application
  config_source_folder  = format("%s/%s", "values", each.value.release.name)
  config_hash_file      = format("%s_%s", ".values_hash", each.value.release.name)

  github_package = try(each.value.release.source.githubPackages.name, "") != "" && try(each.value.release.source.githubPackages.type, "") != ""
  package_name   = try(each.value.release.source.githubPackages.name, "")
  package_type   = try(each.value.release.source.githubPackages.type, "")

  extra_run_command = try(each.value.release.extra_run_command, "")
}

module "app" {
  for_each = local.configurations

  source          = "cloudopsworks/beanstalk-deploy/aws"
  version         = "1.0.12"
  region          = var.region
  sts_assume_role = var.sts_assume_role

  release_name   = each.value.release.name
  namespace      = var.namespace
  solution_stack = each.value.beanstalk.solution_stack

  application_version_label = module.version[each.key].application_version_label

  private_subnets = each.value.beanstalk.networking.private_subnets
  public_subnets  = each.value.beanstalk.networking.public_subnets
  vpc_id          = each.value.beanstalk.networking.vpc_id
  server_types    = each.value.beanstalk.instance.server_types

  beanstalk_application          = each.value.beanstalk.application
  beanstalk_ec2_key              = can(each.value.beanstalk.instance.ec2_key) ? each.value.beanstalk.instance.ec2_key : null
  beanstalk_ami_id               = can(each.value.beanstalk.instance.ami_id) ? each.value.beanstalk.instance.ami_id : null
  beanstalk_instance_port        = each.value.beanstalk.instance.instance_port
  beanstalk_enable_spot          = each.value.beanstalk.instance.enable_spot
  beanstalk_default_retention    = each.value.beanstalk.instance.default_retention
  beanstalk_instance_volume_size = each.value.beanstalk.instance.volume_size
  beanstalk_instance_volume_type = each.value.beanstalk.instance.volume_type
  beanstalk_instance_profile     = can(each.value.beanstalk.iam.instance_profile) ? each.value.beanstalk.iam.instance_profile : null
  beanstalk_service_role         = can(each.value.beanstalk.iam.service_role) ? each.value.beanstalk.iam.service_role : null
  beanstalk_min_instances        = try(each.value.beanstalk.instance.pool.min, 1)
  beanstalk_max_instances        = try(each.value.beanstalk.instance.pool.max, 1)

  load_balancer_shared             = try(each.value.beanstalk.load_balancer.shared.enabled, false)
  load_balancer_shared_name        = try(each.value.beanstalk.load_balancer.shared.name, "")
  load_balancer_shared_weight      = try(each.value.beanstalk.load_balancer.shared.weight, 100)
  load_balancer_public             = each.value.beanstalk.load_balancer.public
  load_balancer_log_bucket         = module.logs_bucket.s3_bucket_id
  load_balancer_log_prefix         = each.value.release.name
  load_balancer_ssl_certificate_id = each.value.beanstalk.load_balancer.ssl_certificate_id
  load_balancer_ssl_policy         = can(each.value.beanstalk.load_balancer.ssl_policy) ? each.value.beanstalk.load_balancer.ssl_policy : null
  load_balancer_alias              = can(each.value.beanstalk.load_balancer.alias) ? each.value.beanstalk.load_balancer.alias : null

  port_mappings  = each.value.beanstalk.port_mappings
  rule_mappings  = try(each.value.beanstalk.rule_mappings, [])
  extra_tags     = each.value.beanstalk.extra_tags
  extra_settings = each.value.beanstalk.extra_settings
}

