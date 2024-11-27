variable "sysdig_accesskey" {
  description = "sysdig access key"
  sensitive   = true
  type        = string
}

variable "aws_profile" {
  description = "aws profile to use."
  type        = string
  default     = "sysdig"
}

variable "aws_region" {
  description = "aws region to be used"
  type        = string
  default     = "us-east-1"
}

variable "sysdig_region" {
  description = "Sysdig region to be used"
  type        = string
  default     = "us4"
}

variable "use_assumed_role" {
  description = "value to determine if we are using an assumed role"
  type        = bool
  default     = true
}

variable "sysdig_secure_url" {
  description = "endpoint for sysdig secure/monitor"
  type        = string
  default     = "https://app.us4.sysdig.com"
}

# variable "aws_registry_url" {
#   description = "aws ECR url"
#   type        = string
# }

# variable "prometheus_remote_writer_access_key" {
#   description = "prometheus remote writer access key."
#   sensitive   = true
#   type        = string
# }

# variable "sysdig_secure_api_token" {
#   description = "sysdig secure api token"
#   type        = string
#   sensitive   = true
# }

