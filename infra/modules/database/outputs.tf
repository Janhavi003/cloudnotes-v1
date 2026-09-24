output "database_name" {
  value       = google_sql_database_instance.cloudnotes.name
  description = "Cloud SQL instance name."
}

output "connection_name" {
  value       = google_sql_database_instance.cloudnotes.connection_name
  description = "Cloud SQL connection name."
}
