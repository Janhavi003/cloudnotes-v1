output "app_sa_email" {
  value       = google_service_account.app.email
  description = "Email address of the CloudNotes application service account."
}
