terraform {
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "~> 1.85.3" # use latest from https://registry.terraform.io/providers/terraform-routeros/routeros/latest
    }
  }
  required_version = ">= 1.12.2"
}

provider "routeros" {
  hosturl  = var.routeros_hosturl # Must include api:// or http://
  username = var.routeros_user
  password = var.routeros_password
}


