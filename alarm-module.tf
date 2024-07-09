##
# (c) 2023 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
data "aws_sns_topic" "topic_destination" {
  for_each = local.alarm_configurations
  name     = each.value.alarms.destination_topic
}


resource "aws_cloudwatch_metric_alarm" "metric_alarm" {
  for_each = local.alarm_configurations

  alarm_name          = format("MetricsAlarm-%s-%s-%s", var.region, each.value.release.name, var.namespace)
  comparison_operator = "GreaterThanThreshold"
  statistic           = "Maximum"
  threshold           = each.value.alarms.threshold
  period              = each.value.alarms.period
  evaluation_periods  = each.value.alarms.evaluation_periods
  namespace           = "AWS/ElasticBeanstalk"
  metric_name         = "EnvironmentHealth"
  alarm_description   = "Metric Alarm for Beanstalk Application Health"
  actions_enabled     = true
  ok_actions = [
    data.aws_sns_topic.topic_destination[each.key].arn
  ]
  alarm_actions = [
    data.aws_sns_topic.topic_destination[each.key].arn
  ]
  dimensions = {
    EnvironmentName = module.app[each.key].environment_name
  }
  tags = merge(local.tags[each.key], module.tags.locals.common_tags)
}
