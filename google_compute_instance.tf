variable "project" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for the instance"
  type        = string
}

variable "zone" {
  description = "GCP zone for the instance"
  type        = string
}

resource "google_compute_instance" "vm-instance" {
  name         = "vm-instance"
  machine_type = "e2-micro"
  zone         = var.zone
  project      = var.project

  tags = []

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral external IP; no static IP reservation to keep cost low
    }
  }

  # Minimal service account scope: this VM only serves static files and does
  # not need to call any GCP APIs.
  service_account {
    scopes = ["userinfo-email"]
  }
}

output "instance_name" {
  description = "Name of the created compute instance"
  value       = google_compute_instance.vm-instance.name
}

output "instance_external_ip" {
  description = "External IP address of the instance"
  value       = google_compute_instance.vm-instance.network_interface[0].access_config[0].nat_ip
}
