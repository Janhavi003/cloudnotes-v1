variable "bucket_name" {
  type        = string
  description = "Globally unique Cloud Storage bucket name."
}

variable "location" {
  type        = string
  description = "Cloud Storage bucket location."
}

variable "project_id" {
  type        = string
  description = "GCP project ID for the bucket."
}
