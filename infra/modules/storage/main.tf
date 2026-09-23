resource "google_storage_bucket" "assets" {
  name                        = var.bucket_name
  location                    = var.location
  project                     = var.project_id
  uniform_bucket_level_access = true
  force_destroy               = false

  labels = {
    application = "cloudnotes"
  }
}
