data "yandex_compute_image" "this" {
  name = "${var.image_name}-${var.image_tag}"
}

resource "yandex_compute_instance_group" "this" {
  name                = var.instance_group_name
  folder_id           = var.folder_id
  service_account_id  = yandex_iam_service_account.this.id
  deletion_protection = false
  labels              = var.labels

  depends_on = [
    yandex_iam_service_account.this,
    yandex_vpc_subnet.this,
    yandex_resourcemanager_folder_iam_binding.this,
    yandex_vpc_network.this,
    yandex_vpc_subnet.this
  ]

  instance_template {
    platform_id = "standard-v1"
    labels      = var.labels
    resources {
      cores  = var.resources.cpu
      memory = var.resources.memory
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.this.id
        size     = var.resources.disk
      }
    }

    network_interface {
      network_id = yandex_vpc_network.this.id
      nat        = true
    }

    metadata = {
      ssh-keys = "${var.ssh_user}:${var.public_ssh_key_path != "" ? file(var.public_ssh_key_path) : tls_private_key.key_tls[0].public_key_openssh}"
    }

    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = var.az
  }

  deploy_policy {
    max_unavailable = 2
    max_expansion   = 2
  }
}