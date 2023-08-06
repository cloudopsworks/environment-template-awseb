##
# (c) 2023 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

## API GATEWAY LINK ENABLED only
# Will create all new link and NLB for the beanstalk environment.
# If you want to use an existing NLB, use the `vpc_link.use_existing = true` option
resource "aws_api_gateway_vpc_link" "apigw_rest_link" {
  for_each = local.apigw_nlb_configurations

  name        = "api-gw-nlb-${lower(each.value.release.name)}-${var.namespace}-nlb-link"
  description = "VPC Link for API Gateway to NLB: api-gw-nlb-${lower(each.value.release.name)}-${var.namespace}"
  target_arns = [aws_lb.apigw_rest_lb[each.key].arn]
  tags        = local.tags[each.key]
}

#resource "aws_apigatewayv2_vpc_link" "apigw_http_link" {
#  for_each = local.apigw_nlb_configurations
#
#  name = "api-${lower(each.value.release.name)}-${var.namespace}-vpc-link"
#  subnet_ids = each.value.beanstalk.networking.private_subnets
#  security_group_ids = []
#  tags = local.tags[each.key]
#}

resource "aws_lb" "apigw_rest_lb" {
  for_each = local.apigw_nlb_configurations

  name               = "api-gw-nlb-${lower(each.value.release.name)}-${var.namespace}"
  internal           = !each.value.beanstalk.load_balancer.public
  load_balancer_type = "network"
  subnets            = each.value.beanstalk.load_balancer.public ? each.value.beanstalk.networking.public_subnets : each.value.beanstalk.networking.private_subnets
  tags               = local.tags[each.key]
}

resource "aws_lb_target_group" "apigw_rest_lb_tg" {
  for_each = local.apigw_nlb_configurations

  name        = "tg-${lower(each.value.release.name)}-${var.namespace}-443"
  target_type = "alb"
  protocol    = "TCP"
  port        = 443
  vpc_id      = each.value.beanstalk.networking.vpc_id
  tags        = local.tags[each.key]
}

resource "aws_lb_target_group_attachment" "apigw_rest_lb_tg_att" {
  for_each = local.apigw_nlb_configurations

  target_group_arn = aws_lb_target_group.apigw_rest_lb_tg[each.key].arn
  target_id        = module.app[each.key].load_balancer_id
}

resource "aws_lb_listener" "apigw_rest_lb_listener" {
  for_each = local.apigw_nlb_configurations

  load_balancer_arn = aws_lb.apigw_rest_lb[each.key].arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apigw_rest_lb_tg[each.key].arn
  }
  tags = local.tags[each.key]
}

## EXISTING NLB
# api_gateway:
#   vpc_link:
#     use_existing: true

data "aws_lb" "apigw_rest_lb_link" {
  for_each = local.apiqw_nlb_vpc_links

  name = each.value.api_gateway.vpc_link.lb_name
}

resource "aws_lb_target_group" "apigw_rest_lb_tg_link" {
  for_each = local.apiqw_nlb_vpc_links

  name        = "tg-${lower(each.value.release.name)}-${var.namespace}-${each.value.api_gateway.vpc_link.listener_port}"
  target_type = "alb"
  protocol    = "TCP"
  port        = try(each.value.api_gateway.vpc_link.to_port, each.value.api_gateway.vpc_link.listener_port)
  vpc_id      = each.value.beanstalk.networking.vpc_id
  tags        = local.tags[each.key]
}

resource "aws_lb_target_group_attachment" "apigw_rest_lb_tg_att_link" {
  for_each = local.apiqw_nlb_vpc_links

  target_group_arn = aws_lb_target_group.apigw_rest_lb_tg_link[each.key].arn
  target_id        = module.app[each.key].load_balancer_id
}


resource "aws_lb_listener" "apigw_rest_lb_listener_link" {
  for_each = local.apiqw_nlb_vpc_links

  load_balancer_arn = data.aws_lb.apigw_rest_lb_link[each.key].arn
  port              = each.value.api_gateway.vpc_link.listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apigw_rest_lb_tg_link[each.key].arn
  }
  tags = local.tags[each.key]

  lifecycle {
    replace_triggered_by = [aws_lb_target_group.apigw_rest_lb_tg_link[each.key]]
  }
}
