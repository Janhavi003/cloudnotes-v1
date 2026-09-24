variable "project_id" {
  type        = string
  description = "GCP project ID for the compute instance."
}

variable "instance_name" {
  type        = string
  description = "Name of the CloudNotes VM."
}

variable "machine_type" {
  type        = string
  description = "Compute Engine machine type."
}

variable "zone" {
  type        = string
  description = "Compute Engine zone."
}

variable "boot_image" {
  type        = string
  description = "Boot image for the VM."
}

variable "app_port" {
  type        = number
  description = "Application port used by CloudNotes."
}

variable "subnet_id" {
  type        = string
  description = "Application subnet ID supplied by the network module."
}

variable "sa_email" {
  type        = string
  description = "Service account email supplied by the IAM module."
}
