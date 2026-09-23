output "network_id" {
  value       = google_compute_network.vpc.id
  description = "ID of the VPC network."
}

output "app_subnet_id" {
  value       = google_compute_subnetwork.app.id
  description = "ID of the application subnet."
}

output "web_subnet_id" {
  value       = google_compute_subnetwork.web.id
  description = "ID of the web subnet."
}

output "db_subnet_id" {
  value       = google_compute_subnetwork.db.id
  description = "ID of the database subnet."
}
