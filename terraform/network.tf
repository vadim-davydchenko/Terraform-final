locals {
  prefix = "slurm"
}

resource "yandex_vpc_network" "this" {
  name   = local.prefix
  labels = var.labels
}

resource "yandex_vpc_subnet" "this" {
  for_each       = toset(var.az)
  name           = "${local.prefix}-${each.value}"
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = var.cidr_blocks[index(var.az, each.value)]
  zone           = each.value
  labels         = var.labels
}