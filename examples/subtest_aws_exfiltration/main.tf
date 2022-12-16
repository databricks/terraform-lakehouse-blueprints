variable "databricks_account_username" {}
variable "databricks_account_password" {}
variable "databricks_account_id" {}

variable "tags" {
  default = {}
}

variable "spoke_cidr_block" {
  default = "10.173.0.0/16"
}
variable "hub_cidr_block" {
  default = "10.10.0.0/16"
}
variable "region" {
  default = "eu-central-1"
}

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}
variable "whitelisted_urls" {
  default = [".pypi.org", ".pythonhosted.org", ".cran.r-project.org"]
}

variable "db_web_app" {
  default = "frankfurt.cloud.databricks.com"
}

variable "db_tunnel" {
  default = "tunnel.eu-central-1.cloud.databricks.com"
}

variable "db_rds" {
  default = "mdv2llxgl8lou0.ceptxxgorjrc.eu-central-1.rds.amazonaws.com"
}

variable "db_control_plane" {
  default = "18.159.44.32/28"
}

variable "prefix" {
  default = "demo"
}

locals {
  prefix                         = "${var.prefix}${random_string.naming.result}"
  spoke_db_private_subnets_cidr  = [cidrsubnet(var.spoke_cidr_block, 3, 0), cidrsubnet(var.spoke_cidr_block, 3, 1)]
  spoke_tgw_private_subnets_cidr = [cidrsubnet(var.spoke_cidr_block, 3, 2), cidrsubnet(var.spoke_cidr_block, 3, 3)]
  hub_tgw_private_subnets_cidr   = [cidrsubnet(var.hub_cidr_block, 3, 0)]
  hub_nat_public_subnets_cidr    = [cidrsubnet(var.hub_cidr_block, 3, 1)]
  hub_firewall_subnets_cidr      = [cidrsubnet(var.hub_cidr_block, 3, 2)]
  sg_egress_ports                = [443, 3306, 6666]
  sg_ingress_protocol            = ["tcp", "udp"]
  sg_egress_protocol             = ["tcp", "udp"]
  availability_zones             = ["${var.region}a", "${var.region}b"]
  db_root_bucket                 = "${var.prefix}${random_string.naming.result}-rootbucket.s3.amazonaws.com"
}
