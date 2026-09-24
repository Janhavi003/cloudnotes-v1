output "instance_id" {
  value       = google_compute_instance.app.id
  description = "ID of the CloudNotes VM."
}

output "external_ip" {
  value       = google_compute_instance.app.network_interface[0].access_config[0].nat_ip
  description = "External IP address of the CloudNotes VM."
}
