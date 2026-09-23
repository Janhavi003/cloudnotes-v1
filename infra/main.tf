module "network" {
  source = "./modules/network"

  network_name      = var.network_name
  region            = var.region
  web_cidr          = var.web_cidr
  app_cidr          = var.app_cidr
  db_cidr           = var.db_cidr
  app_port          = var.app_port
  app_source_ranges = var.app_source_ranges
}

module "iam" {
  source = "./modules/iam"

  project_id        = var.project_id
  service_account_id = var.service_account_id
}

module "compute" {
  source = "./modules/compute"

  project_id   = var.project_id
  instance_name = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  boot_image   = var.boot_image
  app_port     = var.app_port
  subnet_id    = module.network.app_subnet_id
  sa_email     = module.iam.app_sa_email
}

module "database" {
  source = "./modules/database"

  project_id         = var.project_id
  db_name            = var.db_name
  region             = var.db_region
  tier               = var.db_tier
  network_id         = module.network.network_id
  deletion_protection = var.db_deletion_protection
}

module "storage" {
  source = "./modules/storage"

  bucket_name   = var.bucket_name
  location      = var.bucket_location
  project_id    = var.project_id
}
