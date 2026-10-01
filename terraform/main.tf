# 1. Настройка подключения провайдера к удаленному демону через SSH
provider "docker" {
  host     = "ssh://${var.remote_user}@${var.remote_host}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", pathexpand(var.ssh_private_key_path)]
}

# 2. Скачивание легковесного образа Nginx
resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}

# 3. Запуск и поддержание контейнера
resource "docker_container" "web" {
  name  = "nginx_container"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.nginx_external_port
  }

  restart = "unless-stopped"
}
