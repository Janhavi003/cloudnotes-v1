output "app_ip" {
  value       = module.compute.external_ip
  description = "External IP address of the CloudNotes application VM."
}

output "bucket_name" {
  value       = module.storage.bucket_name
  description = "Name of the CloudNotes assets bucket."
}

output "database_name" {
  value       = module.database.database_name
  description = "Name of the CloudNotes database."
}

output "database_connection_name" {
  value       = module.database.connection_name
  description = "Cloud SQL connection name."
}

output "network_id" {
  value       = module.network.network_id
  description = "ID of the CloudNotes VPC network."
}

output "app_subnet_id" {
  value       = module.network.app_subnet_id
  description = "ID of the application subnet."
}

output "service_account_email" {
  value       = module.iam.app_sa_email
  description = "Email address of the CloudNotes application service account."
}
