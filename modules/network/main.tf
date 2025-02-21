resource "google_compute_network" "main" {
  name = "main-network"
}

resource "google_compute_subnetwork" "main" {
  name          = "main-subnetwork"
  network       = google_compute_network.main.self_link
  region        = var.region
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_firewall" "allow_http" {
  name    = "mn-allow-http"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}

resource "google_compute_firewall" "allow_load_balancer" {
  name    = "mn-allow-lb"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["203.0.113.0/24"]
  target_tags   = ["web-server"]
}

