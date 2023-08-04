##
# (c) 2023 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#


resource "aws_lb" "apigw_rest_lb" {
  for_each = local.apigw_nlb_configurations

  name = "api-gw-nlb-${lower(each.value.release.name)}-${var.namespace}"
  internal = ! each.value.beanstalk.load_balancer.public
  load_balancer_type = "network"
  subnets = each.value.beanstalk.load_balancer.public ? each.value.beanstalk.networking.public_subnets : each.value.beanstalk.networking.private_subnets
  tags = local.tags[each.key]
}

resource "aws_lb_target_group" "apigw_rest_lb_tg" {
  for_each = local.apigw_nlb_configurations

  load_balancer_arn = aws_lb.apigw_rest_lb[each.key].arn
  name = "api-gw-nlb-${lower(each.value.release.name)}-${var.namespace}-443"
  target_type = "alb"
  protocol = "TCP"
  port = 443
  vpc_id = each.value.networking.vpc_id
}

resource "aws_lb_target_group_attachment" "apigw_rest_lb_tg_att" {
  for_each = local.apigw_nlb_configurations

  target_group_arn = aws_lb_target_group.apigw_rest_lb_tg[each.key].arn
  target_id = module.app[each.key].beanstalk_environment_id
}

resource "aws_lb_listener" "apigw_rest_lb_listener" {
  for_each = local.apigw_nlb_configurations

  load_balancer_arn = aws_lb.apigw_rest_lb[each.key].arn
  port = 443
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.apigw_rest_lb_tg[each.key].arn
  }
}