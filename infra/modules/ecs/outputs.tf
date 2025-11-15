output "ecs_cluster_name" {
  value = aws_ecs_cluster.url_cluster_tf.name
}

output "ecs_service_name" {
  value = aws_ecs_service.url_service_tf.name
}