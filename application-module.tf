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
}

##
# This module to manage DNS association.
#   - This can be commented out to disable DNS management (not recommended)
#
module "dns" {
  for_each = local.configurations

  source          = "cloudopsworks/beanstalk-dns/aws"
  version         = "1.0.1"
  region          = var.region
  sts_assume_role = var.sts_assume_role

  release_name                = each.value.release.name
  namespace                   = var.namespace
  domain_name                 = each.value.dns.domain_name
  domain_name_alias_prefix    = each.value.dns.alias_prefix
  beanstalk_environment_cname = module.app[each.key].environment_cname
}

module "version" {
  for_each = local.configurations

  source          = "cloudopsworks/beanstalk-version/aws"
  version         = "1.0.2"
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
  # force_source_compressed = true
  # source_compressed_type  = "zip"

  application_versions_bucket = local.application_versions_bucket

  beanstalk_application = each.value.beanstalk.application
  #source_folder         = "values/${each.value.release.name}"
}

module "app" {
  for_each = local.configurations

  source          = "cloudopsworks/beanstalk-deploy/aws"
  version         = "1.0.3"
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

  load_balancer_public             = each.value.beanstalk.load_balancer.public
  load_balancer_log_bucket         = local.load_balancer_log_bucket
  load_balancer_log_prefix         = each.value.release.name
  load_balancer_ssl_certificate_id = each.value.beanstalk.load_balancer.ssl_certificate_id
  load_balancer_ssl_policy         = can(each.value.beanstalk.load_balancer.ssl_policy) ? each.value.beanstalk.load_balancer.ssl_policy : null
  load_balancer_alias              = can(each.value.beanstalk.load_balancer.alias) ? each.value.beanstalk.load_balancer.alias : null

  port_mappings  = each.value.beanstalk.port_mappings
  extra_tags     = each.value.beanstalk.extra_tags
  extra_settings = each.value.beanstalk.extra_settings
}

