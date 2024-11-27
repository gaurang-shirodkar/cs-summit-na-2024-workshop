variable "sysdig_secure_api_token" {
  description = "sysdig secure api token"
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

variable "sysdig_endpoint" {
  description = "value of sysdig endpoint"
  type        = string
  default     = "https://app.us4.sysdig.com"
}
