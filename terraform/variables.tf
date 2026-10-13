variable "remote_host" {
  description = "IP address of the remote VM"
  type        = string
}

variable "remote_user" {
  description = "User with docker permissions on remote VM"
  type        = string
  default     = "deployer"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key for connection"
  type        = string
  default     = "~/.ssh/id_ed25519"
}

variable "nginx_external_port" {
  description = "External port for Nginx container"
  type        = number
  default     = 8080
}
