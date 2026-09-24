resource "google_compute_instance" "app" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["cloudnotes"]

  boot_disk {
    initialize_params {
      image = var.boot_image
    }
  }

  network_interface {
    subnetwork = var.subnet_id

    access_config {}
  }

  service_account {
    email  = var.sa_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata = {
    application = "cloudnotes"
  }
}
