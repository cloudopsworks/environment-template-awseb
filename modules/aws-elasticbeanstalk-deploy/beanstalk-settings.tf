##
# (c) 2021 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
locals {
  load_balancer_ssl_certificate_arn = "arn:aws:acm:${var.region}:${data.aws_caller_identity.current.account_id}:certificate/${var.load_balancer_ssl_certificate_id}"

  eb_settings_initial = [
    {
      name      = "AccessLogsS3Bucket"
      namespace = "aws:elbv2:loadbalancer"
      resource  = ""
      value     = var.load_balancer_log_bucket
    }
    , {
      name      = "AccessLogsS3Enabled"
      namespace = "aws:elbv2:loadbalancer"
      resource  = ""
      value     = "true"
    }
    , {
      name      = "AccessLogsS3Prefix"
      namespace = "aws:elbv2:loadbalancer"
      resource  = ""
      value     = var.load_balancer_log_prefix
    }
    # , {
    #   name      = "AppSource"
    #   namespace = "aws:cloudformation:template:parameter"
    #   resource  = ""
    #   value     = "https://elasticbeanstalk-platform-assets-us-east-1.s3.amazonaws.com/stalks/eb_corretto8_amazon_linux_2_1.0.2903.0_20211117205923/sampleapp/EBSampleApp-Corretto.zip"
    # }
    # TODO: check!
    # , { 
    #   name      = "Application Healthcheck URL"
    #   namespace = "aws:elasticbeanstalk:application"
    #   resource  = ""
    #   value     = "TCP:${var.beanstalk_instance_port}"
    # }
    , {
      name      = "AssociatePublicIpAddress"
      namespace = "aws:ec2:vpc"
      resource  = ""
      value     = "false"
    }
    , {
      name      = "Automatically Terminate Unhealthy Instances"
      namespace = "aws:elasticbeanstalk:monitoring"
      resource  = ""
      value     = "true"
    }
    , {
      name      = "Availability Zones"
      namespace = "aws:autoscaling:asg"
      resource  = ""
      value     = "Any"
    }
    , {
      name      = "BatchSize"
      namespace = "aws:elasticbeanstalk:command"
      resource  = ""
      value     = "100"
    }
    , {
      name      = "BatchSizeType"
      namespace = "aws:elasticbeanstalk:command"
      resource  = ""
      value     = "Percentage"
    }
    # , {
    #   name      = "BlockDeviceMappings"
    #   namespace = "aws:autoscaling:launchconfiguration"
    #   resource  = ""
    #   value     = ""
    # }
    , {
      name      = "BreachDuration"
      namespace = "aws:autoscaling:trigger"
      resource  = ""
      value     = "5"
    }
    #   , {
    #     name      = "ConfigDocument"
    #     namespace = "aws:elasticbeanstalk:healthreporting:system"
    #     resource  = ""
    #     value     = <<EOT
    # {
    #   "Version": 1,
    #   "CloudWatchMetrics": {
    #     "Instance": {
    #       "RootFilesystemUtil": null,
    #       "CPUIrq": null,
    #       "LoadAverage5min": null,
    #       "ApplicationRequests5xx": null,
    #       "ApplicationRequests4xx": null,
    #       "CPUUser": null,
    #       "LoadAverage1min": null,
    #       "ApplicationLatencyP50": null,
    #       "CPUIdle":null,
    #       "InstanceHealth": null,
    #       "ApplicationLatencyP95": null,
    #       "ApplicationLatencyP85": null,
    #       "ApplicationLatencyP90": null,
    #       "CPUSystem": null,
    #       "ApplicationLatencyP75": null,
    #       "CPUSoftirq": null,
    #       "ApplicationLatencyP10": null,
    #       "ApplicationLatencyP99": null,
    #       "ApplicationRequestsTotal": null,
    #       "ApplicationLatencyP99.9":null,
    #       "ApplicationRequests3xx":null,
    #       "ApplicationRequests2xx":null,
    #       "CPUIowait":null,
    #       "CPUNice":null
    #     },
    #     "Environment": {
    #       "InstancesSevere":null,
    #       "InstancesDegraded":null,
    #       "ApplicationRequests5xx":null,
    #       "ApplicationRequests4xx":null,
    #       "ApplicationLatencyP50":null,
    #       "ApplicationLatencyP95":null,
    #       "ApplicationLatencyP85":null,
    #       "InstancesUnknown":null,
    #       "ApplicationLatencyP90":null,
    #       "InstancesInfo":null,
    #       "InstancesPending":null,
    #       "ApplicationLatencyP75":null,
    #       "ApplicationLatencyP10":null,
    #       "ApplicationLatencyP99":null,
    #       "ApplicationRequestsTotal":null,
    #       "InstancesNoData":null,
    #       "ApplicationLatencyP99.9":null,
    #       "ApplicationRequests3xx":null,
    #       "ApplicationRequests2xx":null,
    #       "InstancesOk":null,
    #       "InstancesWarning":null
    #     }
    #   },
    #   "Rules": {
    #     "Environment": {
    #       "ELB": {
    #         "ELBRequests4xx": {
    #           "Enabled":true
    #         }
    #       },
    #       "Application": {
    #         "ApplicationRequests4xx": {
    #           "Enabled":true
    #         }
    #       }
    #     }
    #   }
    # }
    # EOT
    #   }
    , {
      name      = "Cooldown"
      namespace = "aws:autoscaling:asg"
      resource  = ""
      value     = "360"
    }
    # , {
    #   name      = "Custom Availability Zones"
    #   namespace = "aws:autoscaling:asg"
    #   resource  = ""
    #   value     = ""
    # }
    , {
      name      = "DefaultSSHPort"
      namespace = "aws:elasticbeanstalk:control"
      resource  = ""
      value     = "22"
    }
    , {
      name      = "DeleteOnTerminate"
      namespace = "aws:elasticbeanstalk:cloudwatch:logs"
      resource  = ""
      value     = "false"
    }
    , {
      name      = "DeleteOnTerminate"
      namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
      resource  = ""
      value     = "false"
    }
    , {
      name      = "DeploymentPolicy"
      namespace = "aws:elasticbeanstalk:command"
      resource  = ""
      value     = "AllAtOnce"
    }
    , {
      name      = "DisableIMDSv1"
      namespace = "aws:autoscaling:launchconfiguration"
      resource  = ""
      value     = "true"
    }
    , {
      name      = "EC2KeyName"
      namespace = "aws:autoscaling:launchconfiguration"
      resource  = ""
      value     = var.beanstalk_ec2_key
    }
    , {
      name      = "ELBScheme"
      namespace = "aws:ec2:vpc"
      resource  = ""
      value     = var.load_balancer_public ? "public" : "internal"
    }
    , {
      name      = "ELBSubnets"
      namespace = "aws:ec2:vpc"
      resource  = ""
      value     = var.load_balancer_public ? join(",", var.public_subnets) : join(",", var.private_subnets)
    }
    , {
      name      = "EnableCapacityRebalancing"
      namespace = "aws:autoscaling:asg"
      resource  = ""
      value     = "false"
    }
    , {
      name      = "EnableSpot"
      namespace = "aws:ec2:instances"
      resource  = ""
      value     = tostring(var.beanstalk_enable_spot)
    }
    , {
      name      = "EnhancedHealthAuthEnabled"
      namespace = "aws:elasticbeanstalk:healthreporting:system"
      resource  = ""
      value     = "true"
    }
    , {
      name      = "EnvironmentType"
      namespace = "aws:elasticbeanstalk:environment"
      resource  = ""
      value     = "LoadBalanced"
    }
    # , {
    #   name      = "EnvironmentVariables"
    #   namespace = "aws:cloudformation:template:parameter"
    #   resource  = ""
    #   value     = "M2=/usr/local/apache-maven/bin,M2_HOME=/usr/local/apache-maven,GRADLE_HOME=/usr/local/gradle"
    # }
    , {
      name      = "EvaluationPeriods"
      namespace = "aws:autoscaling:trigger"
      resource  = ""
      value     = "1"
    }
    , {
      name      = "EvaluationTime"
      namespace = "aws:elasticbeanstalk:trafficsplitting"
      resource  = ""
      value     = ""
    }
    # , {
    #   name      = "ExternalExtensionsS3Bucket"
    #   namespace = "aws:elasticbeanstalk:environment"
    #   resource  = ""
    #   value     = ""
    # }
    # , {
    #   name      = "ExternalExtensionsS3Key"
    #   namespace = "aws:elasticbeanstalk:environment"
    #   resource  = ""
    #   value     = ""
    # }
    # , {
    #   name      = "GRADLE_HOME"
    #   namespace = "aws:elasticbeanstalk:application:environment"
    #   resource  = ""
    #   value     = "/usr/local/gradle"
    # }
    , {
      name      = "HasCoupledDatabase"
      namespace = "aws:rds:dbinstance"
      resource  = ""
      value     = "false"
    }

    , {
      name      = "HealthCheckSuccessThreshold"
      namespace = "aws:elasticbeanstalk:healthreporting:system"
      resource  = ""
      value     = "Ok"
    }
    , {
      name      = "HealthStreamingEnabled"
      namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
      resource  = ""
      value     = "true"
    }
    # , {
    #   name      = "HooksPkgUrl"
    #   namespace = "aws:cloudformation:template:parameter"
    #   resource  = ""
    #   value     = "https://elasticbeanstalk-platform-assets-us-east-1.s3.amazonaws.com/stalks/eb_corretto8_amazon_linux_2_1.0.2903.0_20211117205923/lib/hooks.tar.gz"
    # }
    , {
      name      = "IamInstanceProfile"
      namespace = "aws:autoscaling:launchconfiguration"
      resource  = ""
      value     = "aws-elasticbeanstalk-ec2-role"
    }
    # , {
    #   name      = "IdleTimeout"
    #   namespace = "aws:elbv2:loadbalancer"
    #   resource  = ""
    #   value     = ""
    # }
    , {
      name      = "IgnoreHealthCheck"
      namespace = "aws:elasticbeanstalk:command"
      resource  = ""
      value     = "false"
    }
    , {
      name      = "ImageId"
      namespace = "aws:autoscaling:launchconfiguration"
      resource  = ""
      value     = var.beanstalk_ami_id
    }
    , {
      name      = "InstancePort"
      namespace = "aws:cloudformation:template:parameter"
      resource  = ""
      value     = tostring(var.beanstalk_instance_port)
    }
    , {
      name      = "InstanceRefreshEnabled"
      namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
      resource  = ""
      value     = "false"
    }
    , {
      name      = "InstanceType"
      namespace = "aws:autoscaling:launchconfiguration"
      resource  = ""
      value     = var.server_types[0]
    }
    # , {
    #   name      = "InstanceTypeFamily"
    #   namespace = "aws:cloudformation:template:parameter"
    #   resource  = ""
    #   value     = "t3a"
    # }
    , {
      name      = "InstanceTypes"
      namespace = "aws:ec2:instances"
      resource  = ""
      value     = join(", ", var.server_types)
    }
    , {
      name      = "LaunchTimeout"
      namespace = "aws:elasticbeanstalk:control"
      resource  = ""
      value     = "0"
    }
    , {
      name      = "LaunchType"
      namespace = "aws:elasticbeanstalk:control"
      resource  = ""
      value     = "Migration"
    }
    # , {
    #   name      = "LoadBalancerIsShared"
    #   namespace = "aws:elasticbeanstalk:environment"
    #   resource  = ""
    #   value     = "false"
    # }
    , {
      name      = "LoadBalancerType"
      namespace = "aws:elasticbeanstalk:environment"
      resource  = ""
      value     = "application"
    }
    , {
      name      = "LogPublicationControl"
      namespace = "aws:elasticbeanstalk:hostmanager"
      resource  = ""
      value     = "false"
    }
    , {
      name      = "LowerBreachScaleIncrement"
      namespace = "aws:autoscaling:trigger"
      resource  = ""
      value     = "-1"
    }
    , {
      name      = "LowerThreshold"
      namespace = "aws:autoscaling:trigger"
      resource  = ""
      value     = "2000000"
    }
    # , {
    #   name      = "M2"
    #   namespace = "aws:elasticbeanstalk:application:environment"
    #   resource  = ""
    #   value     = "/usr/local/apache-maven/bin"
    # }
    # , {
    #   name      = "M2_HOME"
    #   namespace = "aws:elasticbeanstalk:application:environment"
    #   resource  = ""
    #   value     = "/usr/local/apache-maven"
    # }
    , {
      name      = "ManagedActionsEnabled"
      namespace = "aws:elasticbeanstalk:managedactions"
      resource  = ""
      value     = "false"
    }
    , {
      name      = "MaxBatchSize"
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      resource  = ""
      value     = ""
    }
    , {
      name      = "MaxSize"
      namespace = "aws:autoscaling:asg"
      resource  = ""
      value     = tostring(var.beanstalk_max_instances)
    }
    , {
      name      = "MeasureName"
      namespace = "aws:autoscaling:trigger"
      resource  = ""
      value     = "NetworkOut"
    }
    , {
      name      = "MinInstancesInService"
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      resource  = ""
      value     = ""
    }
    , {
      name      = "MinSize"
      namespace = "aws:autoscaling:asg"
      resource  = ""
      value     = tostring(var.beanstalk_min_instances)
    }
    , {
      name      = "MonitoringInterval"
      namespace = "aws:autoscaling:launchconfiguration"
      resource  = ""
      value     = "5 minute"
    }
    , {
      name      = "NewVersionPercent"
      namespace = "aws:elasticbeanstalk:trafficsplitting"
      resource  = ""
      value     = ""
    }
    # , {
    #   name      = "Notification Endpoint"
    #   namespace = "aws:elasticbeanstalk:sns:topics"
    #   resource  = ""
    #   value     = ""
    # }
    # , {
    #   name      = "Notification Protocol"
    #   namespace = "aws:elasticbeanstalk:sns:topics"
    #   resource  = ""
    #   value     = "email"
    # }
    # , {
    #   name      = "Notification Topic ARN"
    #   namespace = "aws:elasticbeanstalk:sns:topics"
    #   resource  = ""
    #   value     = ""
    # }
    # , {
    #   name      = "Notification Topic Name"
    #   namespace = "aws:elasticbeanstalk:sns:topics"
    #   resource  = ""
    #   value     = ""
    # }
    , {
      name      = "PauseTime"
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      resource  = ""
      value     = ""
    }
    , {
      name      = "Period"
      namespace = "aws:autoscaling:trigger"
      resource  = ""
      value     = "5"
    }

    # , {
    #   name      = "PreferredStartTime"
    #   namespace = "aws:elasticbeanstalk:managedactions"
    #   resource  = ""
    #   value     = ""
    # }

    , {
      name      = "RetentionInDays"
      namespace = "aws:elasticbeanstalk:cloudwatch:logs"
      resource  = ""
      value     = tostring(var.beanstalk_default_retention)
    }
    , {
      name      = "RetentionInDays"
      namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
      resource  = ""
      value     = tostring(var.beanstalk_default_retention)
    }
    , {
      name      = "RollbackLaunchOnFailure"
      namespace = "aws:elasticbeanstalk:control"
      resource  = ""
      value     = "false"
    }
    , {
      name      = "RollingUpdateEnabled"
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      resource  = ""
      value     = "false"
    }
    , {
      name      = "RollingUpdateType"
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      resource  = ""
      value     = "Time"
    }
    # , {
    #   name      = "RootVolumeIOPS"
    #   namespace = "aws:autoscaling:launchconfiguration"
    #   resource  = ""
    #   value     = ""
    # }
    , {
      name      = "RootVolumeSize"
      namespace = "aws:autoscaling:launchconfiguration"
      resource  = ""
      value     = tostring(var.beanstalk_instance_volume_size)
    }
    # , {
    #   name      = "RootVolumeThroughput"
    #   namespace = "aws:autoscaling:launchconfiguration"
    #   resource  = ""
    #   value     = ""
    # }
    , {
      name      = "RootVolumeType"
      namespace = "aws:autoscaling:launchconfiguration"
      resource  = ""
      value     = var.beanstalk_instance_volume_type
    }
    , {
      name      = "SSHSourceRestriction"
      namespace = "aws:autoscaling:launchconfiguration"
      resource  = ""
      value     = "tcp,22,22,0.0.0.0/0"
    }
    # , {
    #   name      = "SSLCertificateArns"
    #   namespace = "aws:elbv2:listener:default"
    #   resource  = ""
    #   value     = ""
    # }
    # , {
    #   name      = "SSLPolicy"
    #   namespace = "aws:elbv2:listener:default"
    #   resource  = ""
    #   value     = ""
    # }
    , {
      name      = "SecurityGroups"
      namespace = "aws:autoscaling:launchconfiguration"
      resource  = ""
      value     = ""
    }
    , {
      name      = "SecurityGroups"
      namespace = "aws:elbv2:loadbalancer"
      resource  = ""
      value     = ""
    }
    , {
      name      = "ServiceRole"
      namespace = "aws:elasticbeanstalk:environment"
      resource  = ""
      value     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-elasticbeanstalk-service-role"
    }
    , {
      name      = "ServiceRoleForManagedUpdates"
      namespace = "aws:elasticbeanstalk:managedactions"
      resource  = ""
      value     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-elasticbeanstalk-service-role"
    }
    , {
      name      = "SpotFleetOnDemandAboveBasePercentage"
      namespace = "aws:ec2:instances"
      resource  = ""
      value     = tostring(var.beanstalk_spot_base_ondemand_percent)
    }
    , {
      name      = "SpotFleetOnDemandBase"
      namespace = "aws:ec2:instances"
      resource  = ""
      value     = tostring(var.beanstalk_spot_base_ondemand)
    }
    , {
      name      = "SpotMaxPrice"
      namespace = "aws:ec2:instances"
      resource  = ""
      value     = var.beanstalk_spot_price
    }
    # , {
    #   name      = "StaticFiles"
    #   namespace = "aws:cloudformation:template:parameter"
    #   resource  = ""
    #   value     = ""
    # }
    , {
      name      = "Statistic"
      namespace = "aws:autoscaling:trigger"
      resource  = ""
      value     = "Average"
    }
    , {
      name      = "StreamLogs"
      namespace = "aws:elasticbeanstalk:cloudwatch:logs"
      resource  = ""
      value     = "true"
    }
    , {
      name      = "Subnets"
      namespace = "aws:ec2:vpc"
      resource  = ""
      value     = join(",", var.private_subnets)
    }
    , {
      name      = "SupportedArchitectures"
      namespace = "aws:ec2:instances"
      resource  = ""
      value     = "x86_64"
    }
    , {
      name      = "SystemType"
      namespace = "aws:elasticbeanstalk:healthreporting:system"
      resource  = ""
      value     = "enhanced"
    }
    , {
      name      = "Timeout"
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      resource  = ""
      value     = "PT30M"
    }
    , {
      name      = "Timeout"
      namespace = "aws:elasticbeanstalk:command"
      resource  = ""
      value     = "600"
    }
    , {
      name      = "Unit"
      namespace = "aws:autoscaling:trigger"
      resource  = ""
      value     = "Bytes"
    }
    # , {
    #   name      = "UpdateLevel"
    #   namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    #   resource  = ""
    #   value     = ""
    # }
    , {
      name      = "UpperBreachScaleIncrement"
      namespace = "aws:autoscaling:trigger"
      resource  = ""
      value     = "1"
    }
    , {
      name      = "UpperThreshold"
      namespace = "aws:autoscaling:trigger"
      resource  = ""
      value     = "6000000"
    }
    , {
      name      = "VPCId"
      namespace = "aws:ec2:vpc"
      resource  = ""
      value     = var.vpc_id
    }
    , {
      name      = "XRayEnabled"
      namespace = "aws:elasticbeanstalk:xray"
      resource  = ""
      value     = "false"
    }
  ]

  eb_settings = concat(local.eb_settings_initial, local.port_mappings_local, local.ssl_mappings)
}