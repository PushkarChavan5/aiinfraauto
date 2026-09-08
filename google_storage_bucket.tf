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

resource "google_storage_bucket" "secure_data_bucket" {
  name                        = "secure-data-bucket"
  project                     = var.project_id
  location                    = "US"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = false
  }
}

output "bucket_url" {
  description = "gs:// URL of the created GCS bucket"
  value       = google_storage_bucket.secure_data_bucket.url
}
