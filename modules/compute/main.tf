resource "google_compute_instance" "temp_vm" {
  name         = "temp-vm"
  machine_type = var.machine_type
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-11-bullseye-v20220118"
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata_startup_script = <<-EOF
	#!/bin/bash
	apt-get update -y
	apt-get install -y apache2
	echo "<h1>Hello from $(hostname)</h1>"> /var/www/html/index.html
	systemctl enable apache2
	systemctl start apache2
	EOF

  tags = ["web-server"]
}
resource "null_resource" "stop_temp_vm" {
  provisioner "local-exec" {
    command = "gcloud compute instances stop ${google_compute_instance.temp_vm.name} --zone=${google_compute_instance.temp_vm.zone}"
  }

  depends_on = [google_compute_instance.temp_vm]
}

resource "google_compute_image" "temp_vm_image" {
  name        = "custom-apache-image"
  source_disk = google_compute_instance.temp_vm.boot_disk.0.source

  depends_on = [null_resource.stop_temp_vm]
}

resource "google_compute_instance_template" "web_instance_template" {
  name         = "web-instance-template"
  machine_type = var.machine_type
  region       = var.region

  disk {
    auto_delete  = true
    boot         = true
    source_image = google_compute_image.temp_vm_image.self_link
  }
  network_interface {
    network = "default"
    access_config {}
  }

}

resource "google_compute_target_pool" "app_target_pool" {
  name = "web-app-target-pool"
}

resource "google_compute_instance_group_manager" "web_instance_group" {
  name = "web-instance-group"
  zone = var.zone
  version {
    instance_template = google_compute_instance_template.web_instance_template.self_link
  }
  target_pools = [google_compute_target_pool.app_target_pool.self_link]
  named_port {
    name = "http"
    port = 80
  }
  base_instance_name = "web-instance"
  target_size        = var.number_of_VMs
}

resource "google_compute_health_check" "app_health_check" {
  name        = "app-health-check"
  description = "Health check via tcp"

  timeout_sec         = 5
  check_interval_sec  = 5
  healthy_threshold   = 4
  unhealthy_threshold = 5

  tcp_health_check {
    port = 80
  }
}

resource "google_compute_forwarding_rule" "app_forwarding_rule" {
  name        = "web-app-forwarding-rule"
  target      = google_compute_target_pool.app_target_pool.self_link
  port_range  = "80"
  ip_protocol = "TCP"
  region      = var.region
}
