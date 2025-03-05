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
}

resource "google_compute_router" "nat-router-us-central1" {
  name    = var.compute_router_name
  region  = var.region
  network = google_compute_network.main.self_link
}

resource "google_compute_router_nat" "nat-config1" {
  name                               = var.compute_router_nat["nat_config1"].name
  router                             = google_compute_router.nat-router-us-central1.name
  region                             = var.region
  nat_ip_allocate_option             = var.compute_router_nat["nat_config1"].nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.compute_router_nat["nat_config1"].source_subnetwork_ip_ranges_to_nat
}