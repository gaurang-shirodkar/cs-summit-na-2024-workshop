terraform {
  required_providers {
    sysdig = {
      source = "sysdiglabs/sysdig"
    }
  }
}

provider "sysdig" {
  sysdig_secure_url       = var.sysdig_endpoint
  sysdig_secure_api_token = var.sysdig_secure_api_token
}

provider "aws" {
  region  = var.aws_region
  alias   = "us-east-1"
  profile = var.aws_profile
}