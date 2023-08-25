variable "az" {
  type        = list(string)
  description = "List availability zones"
  default = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-c"
  ]
}

variable "cidr_blocks" {
  type        = list(list(string))
  description = "List subnet"
  default = [
    ["10.1.0.0/16"],
    ["10.2.0.0/16"],
    ["10.3.0.0/16"]
  ]
}

variable "labels" {
  type        = map(string)
  description = "Labels to add resources"
  default = {
    "app" = "final-project"
  }
}

variable "folder_id" {
  type        = string
  description = "Folder-id yandex cloud"
  default     = ""
}

variable "image_name" {
  type        = string
  description = "Image name"
  default     = "nginx"
}

variable "image_tag" {
  type        = string
  description = "Image tag"
  default     = 0
}

variable "instance_group_name" {
  type        = string
  description = "name compute instance"
  default     = "instance-group"
}

variable "resources" {
  type = object({
    cpu    = number
    memory = number
    disk   = number
  })
  description = "parameters for instance"
  default = {
    cpu    = 2
    disk   = 10
    memory = 2
  }
}

variable "ssh_user" {
  description = "SSH user"
  type        = string
  default     = "ubuntu"
}

variable "public_ssh_key_path" {
  type        = string
  description = "Describe ssh key for compute instance"
  default     = ""
}

variable "http_backend_port" {
  type        = number
  description = "Application load balancer backend port"
  default     = 80
}

variable "listener_frontend_port" {
  type        = number
  description = "Application load balancer frontend port"
  default     = 9000
}
