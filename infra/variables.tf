variable "project_id" {
  type        = string
  description = "GCP project ID for CloudNotes."
}

variable "region" {
  type        = string
  description = "GCP region for CloudNotes resources."
  default     = "asia-south1"
}

variable "zone" {
  type        = string
  description = "GCP zone for the CloudNotes application VM."
  default     = "asia-south1-a"
}

variable "web_cidr" {
  type        = string
  description = "CIDR range for the web subnet."
  default     = "10.10.0.0/24"
}

variable "app_cidr" {
  type        = string
  description = "CIDR range for the application subnet."
  default     = "10.10.1.0/24"
}

variable "db_cidr" {
  type        = string
  description = "CIDR range reserved for database-tier addressing."
  default     = "10.10.2.0/24"
}

variable "network_name" {
  type        = string
  description = "Name of the CloudNotes VPC network."
  default     = "cloudnotes-vpc"
}

variable "instance_name" {
  type        = string
  description = "Name of the CloudNotes application VM."
  default     = "cloudnotes-app"
}

variable "machine_type" {
  type        = string
  description = "Compute Engine machine type."
  default     = "e2-micro"
}

variable "boot_image" {
  type        = string
  description = "Compute Engine boot image."
  default     = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2404-lts-amd64"
}

variable "app_port" {
  type        = number
  description = "TCP port exposed by the CloudNotes application."
  default     = 5000
}

variable "app_source_ranges" {
  type        = list(string)
  description = "CIDR ranges allowed to reach the application port."
  default     = ["0.0.0.0/0"]
}

variable "bucket_name" {
  type        = string
  description = "Globally unique Cloud Storage bucket name."
}

variable "bucket_location" {
  type        = string
  description = "Cloud Storage bucket location."
  default     = "ASIA-SOUTH1"
}

variable "db_name" {
  type        = string
  description = "Cloud SQL database name."
  default     = "cloudnotes"
}

variable "db_tier" {
  type        = string
  description = "Cloud SQL machine tier."
  default     = "db-f1-micro"
}

variable "db_region" {
  type        = string
  description = "Cloud SQL region."
  default     = "asia-south1"
}

variable "db_deletion_protection" {
  type        = bool
  description = "Whether Cloud SQL deletion protection is enabled."
  default     = false
}

variable "service_account_id" {
  type        = string
  description = "ID for the CloudNotes application service account."
  default     = "cloudnotes-app"
}
