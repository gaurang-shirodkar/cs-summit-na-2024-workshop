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

variable "event_pattern" {
  description = "Event pattern for CloudWatch Event Rule"
  type        = string
  default     = <<EOF
{
  "detail-type": [
    "AWS API Call via CloudTrail",
    "AWS Console Sign In via CloudTrail",
    "AWS Service Event via CloudTrail"
  ],
  "detail": {
    "eventName": [
      {
        "anything-but": ["GetObject", "HeadObject", "ListObjects", "PutObject", "DeleteObject", "CopyObject", "UploadPart"]
      }
    ]
  }
}
EOF
}

variable "deploy_eks_agentless_scanning" {
  description = "value to deploy eks agentless scanning"
  type        = bool
  default     = false
}

variable "deploy_aws_agentless_host_scanning" {
  description = "value to deploy aws agentless host scanning"
  type        = bool
  default     = false
}

variable "sysdig_endpoint" {
  description = "value of sysdig endpoint"
  type        = string
  default     = "https://app.us4.sysdig.com"
}