output "bucket_name" {
  value       = google_storage_bucket.assets.name
  description = "Name of the CloudNotes assets bucket."
}
