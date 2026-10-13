# 1. Подключение к Docker-демону удаленного хоста по SSH
provider "docker" {
  host     = "ssh://${var.remote_user}@${var.remote_host}:22"
  ssh_opts = [
    "-o", "StrictHostKeyChecking=no",
    "-o", "UserKnownHostsFile=/dev/null",
    "-i", pathexpand(var.ssh_private_key_path)
  ]
}

# 2. Выделенная сеть Docker (изолирована от других контейнеров)
resource "docker_network" "custom_net" {
  name   = "custom-net"
  driver = "bridge"
}

# 3. Выделенный именованный том Docker для данных Nginx
resource "docker_volume" "nginx_volume" {
  name = "nginx-data"
}

# 4. Базовый образ веб-сервера
resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}

# 5. Контейнер Nginx в собственной сети и с подключенным томом
resource "docker_container" "web" {
  name  = "nginx-container"
  image = docker_image.nginx.image_id

  # Подключение к созданной сети
  networks_advanced {
    name = docker_network.custom_net.name
  }

  # Подключение созданного тома
  volumes {
    volume_name    = docker_volume.nginx_volume.name
    container_path = "/usr/share/nginx/html"
  }

  # Проброс на нестандартный порт (8080)
  ports {
    internal = 80
    external = var.nginx_external_port
  }

  restart = "unless-stopped"
}
