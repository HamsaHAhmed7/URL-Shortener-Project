terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.21.0"
    }
  }
}




resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/url-task-definition-tf"
  retention_in_days = 7

  tags = {
    Name = "url-task-definition-tf-logs"
  }
}

resource "aws_ecs_cluster" "url_cluster_tf" {
  name = "url-cluster-tf"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "url-cluster-tf"
  }
}

resource "aws_ecs_task_definition" "url_task_tf" {
  family                   = "url-task-definition-tf"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = var.iam_task_execution_role_arn
  task_role_arn            = var.iam_task_role_arn

  depends_on = [aws_cloudwatch_log_group.ecs_logs]

  container_definitions = jsonencode([
    {
      name      = "url-shortener-app-tf"
      image     = "016873651140.dkr.ecr.eu-west-2.amazonaws.com/url-shortener:latest"
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]

      environment = [
        {
          name  = "TABLE_NAME"
          value = var.dynamodb_table_name
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/url-task-definition-tf"
          awslogs-region        = "eu-west-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = {
    Name = "url-task-definition-tf"
  }
}

resource "aws_ecs_service" "url_service_tf" {
  name            = "url-service-tf"
  cluster         = aws_ecs_cluster.url_cluster_tf.id
  task_definition = aws_ecs_task_definition.url_task_tf.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "url-shortener-app-tf"
    container_port   = 8080
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups  = [var.ecs_security_group_id]
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  tags = {
    Name = "url-service-tf"
  }

  depends_on = [aws_ecs_task_definition.url_task_tf]
}
