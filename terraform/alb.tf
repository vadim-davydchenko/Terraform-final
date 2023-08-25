resource "yandex_alb_target_group" "this" {
  name   = "target-group"
  labels = var.labels
  dynamic "target" {
    for_each = [for s in yandex_compute_instance_group.this.instances : {
      address   = s.network_interface.0.ip_address
      subnet_id = s.network_interface.0.subnet_id
    }]
    content {
      subnet_id  = target.value.subnet_id
      ip_address = target.value.address
    }
  }
}

resource "yandex_alb_backend_group" "this" {
  name = "general-backend"
  labels = var.labels

  http_backend {
    name             = "http-backend"
    weight           = 1
    port             = var.http_backend_port
    target_group_ids = [yandex_alb_target_group.this.id]
    load_balancing_config {
      panic_threshold = 50
    }
    healthcheck {
      timeout          = "3s"
      interval         = "3s"
      healthcheck_port = var.http_backend_port
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "this" {
  name   = "http-router"
  labels = var.labels
}

resource "yandex_alb_virtual_host" "this" {
  name           = "virtual-host"
  http_router_id = yandex_alb_http_router.this.id
  route {
    name = "my-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.this.id
        timeout          = "3s"
      }
    }
  }
}


resource "yandex_alb_load_balancer" "this" {
  name       = "load-balancer"
  network_id = yandex_vpc_network.this.id
  labels     = var.labels

  allocation_policy {
    dynamic "location" {
      for_each = toset(var.az)
      content {
        zone_id   = location.value
        subnet_id = yandex_vpc_subnet.this[location.value].id
      }
    }
  }

  listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [var.listener_frontend_port]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.this.id
      }
    }
  }

  log_options {
    discard_rule {
      http_code_intervals = ["HTTP_2XX"]
      discard_percent     = 75
    }
  }
}