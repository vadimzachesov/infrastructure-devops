output "container_id" {
  description = "ID of the created Docker container"
  value       = docker_container.web.id
}

output "web_url" {
  description = "URL to access the Nginx container"
  value       = "http://${var.remote_host}:${var.nginx_external_port}"
}
