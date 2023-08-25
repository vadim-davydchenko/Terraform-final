packer {
  required_plugins {
    yandex = {
      source  = "github.com/hashicorp/yandex"
      version = ">= 1.1.2"
    }
  }
}

source "yandex" "nginx" {
  folder_id           = var.YC_FOLDER_ID
  source_image_family = var.source_image_family
  ssh_username        = var.ssh_username
  use_ipv4_nat        = var.use_ipv4_nat
  image_description   = var.image_description
  image_family        = var.image_family
  image_name          = "${var.image_name}-${var.image_tag}"
  subnet_id           = var.YC_SUBNET_ID
  disk_type           = var.disk_type
  zone                = var.YC_ZONE
}

build {
  sources = ["source.yandex.nginx"]

  provisioner "ansible" {
    playbook_file = "ansible/playbook.yml"
    user = "ubuntu"
    extra_arguments = [ "--scp-extra-args", "'-O'" ]
  }
}