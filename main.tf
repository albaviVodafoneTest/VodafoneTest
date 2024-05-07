# Terraform

# ---------------------------------------------------------------------------------------------------------------------

# Module description before the optimization

# This tf module imports the defined tf version and initializes the dns provider from hashicorp.
# It is being used to setup a DNS on zone example.com that resolves around the A type regitries imputed manually.

# ---------------------------------------------------------------------------------------------------------------------

# Update of the module description:

# New optimization for the module to dinamically obtain from a .json imported file the A type DNS reg. 
# This way you can add multiple DNS entries on the .JSON format. 

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

  unfiltered = {for x in fileset("${path.module}/${var.pathJson}", "*.json") : trimsuffix(x, ".json") => jsondecode(file("${path.module}/${var.pathJson}/${x}"))}
  filtered = {for k, v in local.unfiltered : k => v if length([for key in ["ttl", "zone", "dns_record_type"] : key if contains(keys(v), key)]) == 3}
  records = {for x in ["a", "aaaa", "cname"] : x => {for k, v in local.filtered : k => v if v.dns_record_type == x}}
  
}


# ------------------------------------------
# Write your Terraform resources here
# ------------------------------------------

resource "dns_a_record_set" "dns-set-a" {
  for_each = local.records.a
  zone = each.value.zone
  name = each.key
  addresses = each.value.addresses
  ttl = each.value.ttl
}

resource "dns_aaaa_record_set" "dns-set-aaaa" {
  for_each = local.records.aaaa
  zone = each.value.zone
  name = each.key
  addresses = each.value.addresses
  ttl = each.value.ttl
}

resource "dns_cname_record" "dns-set-aaaa" {
  for_each = local.records.cname
  zone = each.value.zone
  name = each.key
  cname  = each.value.cname
  ttl = each.value.ttl
}
