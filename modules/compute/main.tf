resource "google_compute_instance" "temp_vm" {
  name         = "${var.environment}temp-vm"
  machine_type = var.machine_type
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    startup-script = file("${path.module}/start_up.sh")
  }
}

resource "null_resource" "stop_temp_vm" {
  provisioner "local-exec" {
    command = "gcloud compute instances stop ${google_compute_instance.temp_vm.name} --zone=${google_compute_instance.temp_vm.zone}"
  }

  depends_on = [google_compute_instance.temp_vm]
}

resource "google_compute_image" "temp_vm_image" {
  name        = var.temp_compute_img_name
  source_disk = google_compute_instance.temp_vm.boot_disk.0.source

  depends_on = [null_resource.stop_temp_vm]
}

resource "google_compute_instance_template" "web_instance_template" {
  name         = var.instance_template["web_instance_template"].name
  machine_type = var.machine_type
  region       = var.region

  disk {
    auto_delete  = var.instance_template["web_instance_template"].disk.auto_delete
    boot         = var.instance_template["web_instance_template"].disk.boot
    source_image = google_compute_image.temp_vm_image.self_link
  }
  network_interface {
    network = var.network_name
  }
  service_account {
    scopes = [
      "service-management",
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring-write",
      "service-control",
    ]
  }
}

resource "google_compute_instance_group_manager" "web_instance_group" {
  name = var.group_manager["web_instance_group"].name
  zone = var.zone
  version {
    instance_template = google_compute_instance_template.web_instance_template.self_link
  }
  named_port {
    name = var.group_manager["web_instance_group"].named_port.name
    port = var.group_manager["web_instance_group"].named_port.port
  }
  base_instance_name = var.group_manager["web_instance_group"].base_instance_name
  target_size        = var.number_of_VMs
}

resource "google_compute_backend_service" "web_map_backend_service" {
  name          = var.web_map_backend_service.name
  protocol      = var.web_map_backend_service.protocol
  port_name     = var.web_map_backend_service.port_name
  health_checks = [google_compute_health_check.app_health_check.id]

  backend {
    group = google_compute_instance_group_manager.web_instance_group.instance_group
  }
}

resource "google_compute_url_map" "web_map" {
  name            = var.web_map_name
  default_service = google_compute_backend_service.web_map_backend_service.self_link
}

resource "google_compute_target_http_proxy" "http_lb_proxy" {
  name    = var.lb_proxy_name
  url_map = google_compute_url_map.web_map.self_link
}

resource "google_compute_health_check" "app_health_check" {
  name = var.health_check["app_health_check"].name

  timeout_sec         = var.health_check["app_health_check"].timeout_sec
  check_interval_sec  = var.health_check["app_health_check"].check_interval_sec
  healthy_threshold   = var.health_check["app_health_check"].healthy_threshold
  unhealthy_threshold = var.health_check["app_health_check"].unhealthy_threshold

  tcp_health_check {
    port = var.health_check["app_health_check"].tcp_health_check.port
  }
}

resource "google_compute_global_forwarding_rule" "app_forwarding_rule" {
  name        = var.forwarding_rule["app_forwarding_rule"].name
  target      = google_compute_target_http_proxy.http_lb_proxy.self_link
  port_range  = var.forwarding_rule["app_forwarding_rule"].port_range
  ip_protocol = var.forwarding_rule["app_forwarding_rule"].ip_protocol
}
