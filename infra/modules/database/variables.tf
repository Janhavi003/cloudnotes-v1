variable "project_id" {
  type        = string
  description = "GCP project ID for the Cloud SQL instance."
}

variable "db_name" {
  type        = string
  description = "Cloud SQL instance name."
}

variable "region" {
  type        = string
  description = "GCP region for Cloud SQL."
}

variable "tier" {
  type        = string
  description = "Cloud SQL machine tier."
}

variable "network_id" {
  type        = string
  description = "VPC network ID for private database connectivity."
}

variable "deletion_protection" {
  type        = bool
  description = "Whether Cloud SQL deletion protection is enabled."
}
