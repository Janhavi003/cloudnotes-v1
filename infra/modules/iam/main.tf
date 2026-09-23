resource "google_service_account" "app" {
  account_id   = var.service_account_id
  display_name = "CloudNotes application service account"
}

resource "google_project_iam_member" "storage_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.app.email}"
}
