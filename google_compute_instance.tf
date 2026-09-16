terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for the instance"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for the instance"
  type        = string
  default     = "us-central1-a"
}

resource "google_compute_instance" "vm_instance" {
  name         = "vm-instance"
  machine_type = "e2-micro"
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // ephemeral external IP
    }
  }
}

output "instance_external_ip" {
  description = "Ephemeral public IP address of the instance"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
