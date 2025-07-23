terraform {
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "~> 1.85.3" # use latest from https://registry.terraform.io/providers/terraform-routeros/routeros/latest
    }
    tfutils = {
      source  = "Yantrio/tfutils"
      version = "~> 0.1.0" # use latest from https://registry.terraform.io/providers/terraform-routeros/tfutils/latest
    }
  }
  required_version = ">= 1.12.2"
}

provider "routeros" {
  hosturl  = var.routeros_hosturl # Must include api:// or http://
  username = var.routeros_user
  password = var.routeros_password
}

# Validation check to ensure management IP is within management subnet
check "management_ip_in_subnet" {
  assert {
    condition = can(cidrhost(var.management_subnet, 0)) && can(provider::tfutils::cidrcontains(var.management_subnet, split("/", var.management_ip)[0]))
    
    error_message = "The management IP address (${split("/", var.management_ip)[0]}) must be within the management subnet (${var.management_subnet})."
  }
}


