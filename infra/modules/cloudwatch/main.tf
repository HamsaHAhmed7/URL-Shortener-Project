
resource "aws_cloudwatch_metric_alarm" "ecs_high_cpu" {
  alarm_name          = "${var.environment}-ecs-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = 60

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_description = "ECS CPU > 80%"
  alarm_actions     = local.alarm_actions
}

resource "aws_cloudwatch_metric_alarm" "ecs_high_memory" {
  alarm_name          = "${var.environment}-ecs-memory-high"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = 60

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_description = "ECS Memory > 80%"
  alarm_actions     = local.alarm_actions
}


resource "aws_cloudwatch_metric_alarm" "dynamodb_throttles" {
  alarm_name          = "${var.environment}-ddb-throttles"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  evaluation_periods  = 1
  metric_name         = "ThrottledRequests"
  namespace           = "AWS/DynamoDB"
  statistic           = "Sum"
  period              = 60

  dimensions = {
    TableName = var.dynamodb_table_name
  }

  alarm_description = "DynamoDB throttles detected"
  alarm_actions     = local.alarm_actions
}

resource "aws_cloudwatch_dashboard" "service_dashboard" {
  dashboard_name = "${var.environment}-url-shortener-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        "type" : "metric",
        "x" : 0,
        "y" : 0,
        "width" : 12,
        "height" : 6,
        "properties" : {
          "title" : "ALB Requests vs 5xx Errors",
          "metrics" : [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_name, { "yAxis" : "left" }],
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", var.alb_name, { "yAxis" : "right" }]
          ],
          "region" : var.aws_region,
          "view" : "timeSeries",
          "stacked" : false
        }
      },
      {
        "type" : "metric",
        "x" : 12,
        "y" : 0,
        "width" : 12,
        "height" : 6,
        "properties" : {
          "title" : "ALB Latency (p50/p95/p99)",
          "metrics" : [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_name, { "stat" : "p50" }],
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_name, { "stat" : "p95" }],
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_name, { "stat" : "p99" }]
          ],
          "region" : var.aws_region,
          "view" : "timeSeries",
          "period" : 60
        }
      },
      {
        "type" : "metric",
        "x" : 0,
        "y" : 6,
        "width" : 12,
        "height" : 6,
        "properties" : {
          "title" : "ECS CPU Utilization",
          "metrics" : [
            ["AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]
          ],
          "region" : var.aws_region,
          "stat" : "Average"
        }
      },
      {
        "type" : "metric",
        "x" : 12,
        "y" : 6,
        "width" : 12,
        "height" : 6,
        "properties" : {
          "title" : "ECS Memory Utilization",
          "metrics" : [
            ["AWS/ECS", "MemoryUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]
          ],
          "region" : var.aws_region,
          "stat" : "Average"
        }
      },
      {
        "type" : "metric",
        "x" : 0,
        "y" : 12,
        "width" : 12,
        "height" : 6,
        "properties" : {
          "title" : "DynamoDB Throttled Requests",
          "metrics" : [
            ["AWS/DynamoDB", "ThrottledRequests", "TableName", var.dynamodb_table_name]
          ],
          "region" : var.aws_region,
          "stat" : "Sum"
        }
      },
      {
        "type" : "metric",
        "x" : 12,
        "y" : 12,
        "width" : 12,
        "height" : 6,
        "properties" : {
          "title" : "ALB Healthy Target Count",
          "metrics" : [
            ["AWS/ApplicationELB", "HealthyHostCount", "LoadBalancer", var.alb_name, "TargetGroup", var.target_group_name]
          ],
          "region" : var.aws_region,
          "stat" : "Average"
        }
      }
    ]
  })
}


resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-cloudwatch-alerts"
}

resource "aws_sns_topic_subscription" "alerts_email" {
  count     = var.alert_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

locals {
  alarm_actions = [aws_sns_topic.alerts.arn]
}
