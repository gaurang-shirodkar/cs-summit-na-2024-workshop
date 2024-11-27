terraform {
  required_providers {
    sysdig = {
      source = "sysdiglabs/sysdig"
    }
  }
}

provider "sysdig" {
  sysdig_monitor_url       = "https://app.us4.sysdig.com"
  sysdig_monitor_api_token = var.sysdig_monitor_api_token
}

provider "aws" {
  region  = var.aws_region
  alias   = "us-east-1"
  profile = var.aws_profile
}