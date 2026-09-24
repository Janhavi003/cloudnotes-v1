resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  description             = "VPC network for CloudNotes."
}

resource "google_compute_subnetwork" "web" {
  name          = "${var.network_name}-web"
  ip_cidr_range = var.web_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "app" {
  name          = "${var.network_name}-app"
  ip_cidr_range = var.app_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "db" {
  name          = "${var.network_name}-db"
  ip_cidr_range = var.db_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_firewall" "app" {
  name    = "${var.network_name}-allow-app"
  network = google_compute_network.vpc.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = [tostring(var.app_port)]
  }

  source_ranges = var.app_source_ranges
  target_tags   = ["cloudnotes"]
}
