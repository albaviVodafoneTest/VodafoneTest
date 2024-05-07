/**
* # Terraform
*

# ---------------------------------------------------------------------------------------------------------------------

* # Update of the module description:

* # New optimization for the module to dinamically obtain from a .json imported file the A type DNS reg. 
* # This way you can add multiple DNS entries on the .JSON format. 

# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM RUNTIME REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------

terraform {

  required_version = ">= 0.13.5"
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3.2.0"
    }
  }
}


# ------------------------------------------
# Write your local resources here
# ------------------------------------------

locals {

}


# ------------------------------------------
# Write your Terraform resources here
# ------------------------------------------

resource "dns_a_record_set" "www" {
  zone = "example.com."
  name = "www"
  addresses = [
    "192.168.0.1",
    "192.168.0.2",
    "192.168.0.3",
  ]
  ttl = 300
}
