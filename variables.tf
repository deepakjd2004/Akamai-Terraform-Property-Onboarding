variable "env" {
  type = string
  description = "a variable to hold akamai network name"
  default = "staging"
}
variable "section" {
  type = string
  description = "a variable to hold edgerc section name"
}
variable "propertyName" {
  type = string
  description = "a variable to hold Property name"
}
variable "email" {
  type = list
  default = ["xxx@zzz.com"]
}
variable "hostname" {
  type = string
  description = "a variable to hold property hostname"
}
variable "groupName" {
  type = string
  description = "a variable to hold group name"
}

variable "cpCodeName" {
  type = string
  description = "a variable to hold cpcode name"
}

variable "productId" {
  type = string
  description = "a variable to hold product ID"
}

variable "originValue" {
  type = string
  description = "a variable to hold product ID"
}

variable "ruleFormat" {
  type = string
  description = "a variable to hold product ID"
  default = "latest"
}

variable "activationNote" {
  type = string
  description = "a variable to hold Activation Note"
}

variable "edgeHostname" {
  type = string
  description = "a variable to hold Edge Hostname"
}
