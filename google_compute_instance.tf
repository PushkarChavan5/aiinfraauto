terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

variable "project_id" {
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

resource "google_compute_instance" "debian_vm" {
  name         = "debian-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral external IP; no static IP reservation to keep cost low
    }
  }

  service_account {
    scopes = ["userinfo-email"]
  }
}

output "instance_external_ip" {
  description = "Ephemeral public IP address of the debian-vm instance"
  value       = google_compute_instance.debian_vm.network_interface[0].access_config[0].nat_ip
}
