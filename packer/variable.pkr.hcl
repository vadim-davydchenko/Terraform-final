variable "YC_FOLDER_ID" {
  type    = string
  default = env("YC_FOLDER_ID")
}

variable "YC_ZONE" {
  type    = string
  default = env("YC_ZONE")
}

variable "YC_SUBNET_ID" {
  type    = string
  default = env("YC_SUBNET_ID")
}

variable "source_image_family" {
  type = string
  default = "ubuntu-2004-lts"
  description = "Source image family name for create custom image"
}

variable "ssh_username" {
  type = string
  default = "ubuntu"
  description = "SSH User"
}

variable "use_ipv4_nat" {
  type = string
  default = "true"
  description = "NAT to get external IP (true or false value)"
}

variable "image_description" {
  type = string
  default = "Ubuntu image with nginx"
  description = "Description of Packer Image"
}

variable "image_family" {
  type = string
  default = "custom-images"
  description = "Packer image family"
}

variable "disk_type" {
  type = string
  default = "network-hdd"
  description = "Disk using template"
}

variable "image_name" {
  type = string
  default = "nginx"
  description = "Packer image name"
}

variable "image_tag" {
  type    = string
  default = 0
}
