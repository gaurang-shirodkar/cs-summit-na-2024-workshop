module "single-account-threat-detection-us-east-1" {
  providers = {
    aws = aws.us-east-1
  }
  source                  = "draios/secure-for-cloud/aws//modules/services/event-bridge"
  target_event_bus_arn    = "arn:aws:events:us-west-2:263844535661:event-bus/us-west-2-gcp-prod-us-4-falco-1"
  trusted_identity        = "arn:aws:iam::263844535661:role/gcp-us4-prod-usw1-secure-benchmark-assume-role"
  external_id             = "b770bf4ded9d1460b5723d6aefcffbf3"
  name                    = "sysdig-secure-events-wxps"
  deploy_global_resources = true
}

module "single-account-cspm" {
  providers = {
    aws = aws.us-east-1
  }
  source           = "draios/secure-for-cloud/aws//modules/services/trust-relationship"
  role_name        = "sysdig-secure-ie78"
  trusted_identity = "arn:aws:iam::263844535661:role/gcp-us4-prod-usw1-secure-benchmark-assume-role"
  external_id      = "b770bf4ded9d1460b5723d6aefcffbf3"
}

module "single-account-agentless-scanning-us-east-1" {
  count = var.deploy_aws_agentless_host_scanning ? 1 : 0

  providers = {
    aws = aws.us-east-1
  }
  source                  = "draios/secure-for-cloud/aws//modules/services/agentless-scanning"
  trusted_identity        = "arn:aws:iam::263844535661:role/gcp-us4-prod-usw1-secure-benchmark-assume-role"
  external_id             = "b770bf4ded9d1460b5723d6aefcffbf3"
  name                    = "sysdig-secure-scanning-gnd0"
  scanning_account_id     = "878070807337"
  deploy_global_resources = true
}

resource "sysdig_secure_cloud_auth_account" "aws_account_835596177334" {
  enabled       = true
  provider_id   = "835596177334"
  provider_type = "PROVIDER_AWS"

  feature {

    secure_threat_detection {
      enabled    = true
      components = ["COMPONENT_EVENT_BRIDGE/secure-runtime"]
    }

    secure_identity_entitlement {
      enabled    = true
      components = ["COMPONENT_EVENT_BRIDGE/secure-runtime", "COMPONENT_TRUSTED_ROLE/secure-posture"]
    }

    secure_config_posture {
      enabled    = true
      components = ["COMPONENT_TRUSTED_ROLE/secure-posture"]
    }

    secure_agentless_scanning {
      enabled    = var.deploy_aws_agentless_host_scanning
      components = ["COMPONENT_TRUSTED_ROLE/secure-scanning", "COMPONENT_CRYPTO_KEY/secure-scanning"]
    }
  }
  component {
    type     = "COMPONENT_TRUSTED_ROLE"
    instance = "secure-posture"
    trusted_role_metadata = jsonencode({
      aws = {
        role_name = "sysdig-secure-ie78"
      }
    })
  }
  component {
    type     = "COMPONENT_EVENT_BRIDGE"
    instance = "secure-runtime"
    event_bridge_metadata = jsonencode({
      aws = {
        role_name = "sysdig-secure-events-wxps"
        rule_name = "sysdig-secure-events-wxps"
      }
    })
  }
  component {
    type     = "COMPONENT_TRUSTED_ROLE"
    instance = "secure-scanning"
    trusted_role_metadata = jsonencode({
      aws = {
        role_name = "sysdig-secure-scanning-gnd0"
      }
    })
  }
  component {
    type     = "COMPONENT_CRYPTO_KEY"
    instance = "secure-scanning"
    crypto_key_metadata = jsonencode({
      aws = {
        kms = {
          alias    = "alias/sysdig-secure-scanning-gnd0"
          regions  = [
            "us-east-1",
          ]
        }
      }
    })
  }
  # depends_on = [module.single-account-agentless-scanning-us-east-1, module.single-account-cspm, module.single-account-threat-detection-us-east-1]
  depends_on = [
    # module.single-account-agentless-scanning-us-east-1, 
    module.single-account-cspm, 
    module.single-account-threat-detection-us-east-1
  ]
}
