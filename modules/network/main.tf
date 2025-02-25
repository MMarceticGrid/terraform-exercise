resource "google_compute_network" "main" {
  name = var.network_name
}

resource "google_compute_subnetwork" "subnets" {
  for_each = var.subnets

  name          = "${each.value.name}-subnet"
  network       = google_compute_network.main.self_link
  region        = each.value.region
  ip_cidr_range = each.value.cidr_range
}

resource "google_compute_firewall" "firewall_rules" {
  for_each = var.firewall_rules

  name    = each.value.name
  network = google_compute_network.main.self_link
  allow {
    protocol = each.value.allowed.protocol
    ports    = each.value.allowed.ports
  }
  source_ranges = each.value.source_ranges
  target_tags   = each.value.target_tags
}

