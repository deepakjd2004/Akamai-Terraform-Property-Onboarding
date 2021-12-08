terraform {
  required_version = "0.14.7"
  required_providers {
    akamai = {
      source = "akamai/akamai"
      version = "1.9.0"
    }
  }
}

provider "akamai" {
 edgerc = "~/.edgerc"
 config_section = var.section
}

// define data source to query group details where resources are to be managed
data "akamai_contract" "contract" {
 group_name = var.groupName
}

// define data element to query contract details where resources are to be managed
data "akamai_group" "group" {
    contract_id = data.akamai_contract.contract.id
    group_name = var.groupName
}

//data source to define the location of the JSON template files and provide information about any user-defined variables included within the templates.
data "akamai_property_rules_template" "rules" {
  template_file = abspath("${path.module}/property-snippets/main.json")
  variables {
    name =  "cpcode_value"
    value = replace(akamai_cp_code.cp_code.id,"cpc_","")
    type = "number"
}
variables {
    name = "origin_value"
    value = var.originValue
    type = "string"
}
}

// Create and manage cp_code
resource "akamai_cp_code" "cp_code" {
 product_id  = var.productId
 contract_id = data.akamai_contract.contract.id
 group_id = data.akamai_group.group.id
 name = var.cpCodeName
}

// Create and manage Edge Hostname

resource "akamai_edge_hostname" "edge_hostname" {
 product_id  = var.productId
 contract_id = data.akamai_contract.contract.id
 group_id = data.akamai_group.group.id
 ip_behavior = "IPV4"
 edge_hostname = var.edgeHostname
}

// Create and manage Akamai Property
resource "akamai_property" "property" {
    name        = var.propertyName
    product_id  = var.productId
    contract_id = data.akamai_contract.contract.id
    group_id    = data.akamai_group.group.id
    hostnames {
      cname_from = var.hostname
      cname_to = var.edgeHostname
      cert_provisioning_type = "CPS_MANAGED"
    }
    rule_format = var.ruleFormat
    rules       = data.akamai_property_rules_template.rules.json
    depends_on = [
        akamai_edge_hostname.edge_hostname
    ]
}

// Activate the property in Staging
resource "akamai_property_activation" "activate_staging" {
     property_id = akamai_property.property.id
     contact  = var.email
     version  = akamai_property.property.latest_version
     network  = "STAGING"
     note = var.activationNote
}

// Activate the property in Production
/*
resource "akamai_property_activation" "activate_prod" {
     property_id = akamai_property.property.id
     contact  = [var.email]
     version  = akamai_property.property.latest_version
     network  = "PRODUCTION"
     note = var.activation_note
     depends_on = [
        akamai_property_activation.activate_staging
     ]
//     count = local.prod_activation_count
}

