variable "network_name" {
  type        = string
  description = "Name of the VPC network."
}

variable "region" {
  type        = string
  description = "GCP region for the subnets."
}

variable "web_cidr" {
  type        = string
  description = "CIDR range for the web subnet."
}

variable "app_cidr" {
  type        = string
  description = "CIDR range for the application subnet."
}

variable "db_cidr" {
  type        = string
  description = "CIDR range for the database subnet."
}

variable "app_port" {
  type        = number
  description = "TCP port exposed by the application."
}

variable "app_source_ranges" {
  type        = list(string)
  description = "CIDR ranges allowed to reach the application port."
}
