variable "sysdig_secure_api_token" {
  description = "sysdig secure api token"
  type        = string
  sensitive   = true
}

variable "sysdig_monitor_api_token" {
  description = "sysdig monitor api token"
  type        = string
  sensitive   = true
}

variable "aws_profile" {
  description = "aws profile to be used"
  type        = string
  default     = "sysdig"
}

variable "aws_region" {
  description = "aws region to be used"
  type        = string
  default     = "us-east-1"
}

variable "sysdig_monitor_url" {
  description = "endpoint for sysdig secure/monitor"
  type        = string
  default     = "https://app.us4.sysdig.com"
}

variable "aws_role_external_id" {
  description = "value for external id"
  type        = string
}

variable "aws_system_account_id" {
  description = "value for aws system account id"
  type        = string
}