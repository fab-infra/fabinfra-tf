terraform {
  required_providers {
    ovh = {
      source = "ovh/ovh"
      version = "~> 0.10"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.13"
}
