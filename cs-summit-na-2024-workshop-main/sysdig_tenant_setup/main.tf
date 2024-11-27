data "aws_caller_identity" "current" {}

resource "sysdig_secure_posture_zone" "aws_zone" {
  name = "AWS zone - Managed by IaC"
  scopes {
    scope {
      target_type = "aws"
      rules       = "account in (\"${data.aws_caller_identity.current.account_id}\")"
    }
  }

  policy_ids = [sysdig_secure_posture_policy.custom_policy.id]
}

resource "sysdig_secure_posture_policy" "custom_policy" {
  name             = "Custom Policy - Custom Controls - Managed by IaC"
  type             = "AWS"
  description      = "Policy to demonstrate custom controls."

  target {
      platform   = "AWS"
  }

  group {
    name        = "EC2"
    description = "EC2 checks"

    requirement {
      name        = "AWS custom controls"
      description = "AWS custom controls"

      control {
        name    = "${sysdig_secure_posture_control.ec2_check_instance_profile_presence.name}"
        enabled = true
      }
      control {
        name    = "${sysdig_secure_posture_control.iam_verify_policies_with_wildcards.name}"
        enabled = true
      }
      control {
        name    = "${sysdig_secure_posture_control.check_presence_of_internet_gateway.name}"
        enabled = true
      }
    }
  }
}
#######################
### CUSTOM CONTROLS ###
#######################
resource "sysdig_secure_posture_control" "ctl1"{
        name = "Custom - RDS - Validate if Engine is Version 16.3"
        description = "AWS - Check if RDS Database is Running the Desired version"
        resource_kind = "AWS_DATABASE"
        severity = "Medium"
        rego = <<-EOF

            package sysdig

            import future.keywords.in
            import future.keywords.if

            default risky := false

            risky if {
              allowed_versions := {"16.3"}
              not input.EngineVersion in allowed_versions
            }
        EOF

        remediation_details = <<-EOF
          **Using AWS CLI**\n 1. This Follow the steps bellow

        EOF
}

resource "sysdig_secure_posture_control" "ctl2"{
        name = "Custom - RDS - Validate if Engine is Version 16.2"
        description = "AWS - Check if RDS Database is Running the Desired version"
        resource_kind = "AWS_DATABASE"
        severity = "Medium"
        rego = <<-EOF

            package sysdig

            import future.keywords.in
            import future.keywords.if

            default risky := false

            risky if {
              allowed_versions := {"16.2"}
              not input.EngineVersion in allowed_versions
            }
        EOF

        remediation_details = <<-EOF
          **Using AWS CLI**\n 1. This Follow the steps bellow

        EOF
}

resource "sysdig_secure_posture_control" "ctl3"{
        name = "Custom - Sysdig - Verify a Major version RDS"
        description = "AWS - a Major version RDS is properly configured"
        resource_kind = "AWS_DATABASE"
        severity = "Medium"
        rego = <<-EOF

            package sysdig

            import future.keywords.if

            default risky := false

            risky if {
                #Validate only major version matches 16
              not regex.match("^(16.)?([0-9].)?([0-9])$", input.EngineVersion)
            }
          
        EOF

        remediation_details = <<-EOF
          **Using Azure CLI**\n 1. This is a test remediation detail

        EOF
}

resource "sysdig_secure_posture_control" "ctl4"{
        name = "Custom - Labels - Validate Mandatory Label"
        description = "AWS - Labels - Validate Mandatory Label [Immutable Backup]"
        resource_kind = "AWS_DATABASE"
        severity = "Medium"
        rego = <<-EOF
          package sysdig

          import future.keywords.if
          import future.keywords.in

          default risky := false

          risky if {
            not has_enabled_category("Immutable Backup")
          }

          has_enabled_category(category) if {
            some i
            input.TagList[i].Key == category
          }
        EOF

        remediation_details = <<-EOF
          **Using AWS CLI**\n 1. This Follow the steps bellow

        EOF
}

resource "sysdig_secure_posture_control" "ctl5"{
        name = "Custom - Labels - Validate Mandatory Label and Value"
        description = "AWS - Labels - Validate Mandatory Label [Immutable Backup = True]"
        resource_kind = "AWS_DATABASE"
        severity = "Medium"
        rego = <<-EOF
          package sysdig

          import future.keywords.if
          import future.keywords.in

          default risky := false

          risky if {
            not has_enabled_category("Immutable Backup","true")
          }

          has_enabled_category(category,value) if {
            some i
            input.TagList[i].Key == category
              input.TagList[i].Value == value
          }


        EOF

        remediation_details = <<-EOF
          **Using AWS CLI**\n 1. This Follow the steps bellow

        EOF
}

resource "sysdig_secure_posture_control" "ec2_check_instance_profile_presence"{
        name = "Custom - InstanceProfile - EC2 Instance should have an Instance Profile associated."
        description = "AWS - EC2 - EC2 Instance should have an Instance Profile associated."
        resource_kind = "AWS_INSTANCE"
        severity = "Medium"
        rego = <<-EOF
          package sysdig

          import future.keywords.if
          import future.keywords.in

          default instance_profile_present := false

          instance_profile_present = true {
            input.IamInstanceProfile
          }

          default risky := false

          risky if {
            not instance_profile_present
          }

        EOF
        remediation_details = <<-EOF
          **Using AWS CLI**\n 1. This Follow the steps bellow
        EOF
}

resource "sysdig_secure_posture_control" "iam_verify_policies_with_wildcards" {
        name = "Custom - IAM Role - Verify policies with wildcards on actions and resources."
        description = "Custom - IAM Role - Verify policies with wildcards on actions and resources."
        resource_kind = "AWS_POLICY"
        severity = "Medium"
        rego = <<-EOF
        package sysdig

        import future.keywords.in

        # Default risky to false
        default risky := false

        # Decode the JSON string in VersionDocument
        version_document := json.unmarshal(input.VersionDocument)

        # Set risky to true if a wildcard is found in Actions
        risky {
            stmt := version_document.Statement[_]
            stmt.Action[_] = action
            contains_wildcard(action)
        }

        # Set risky to true if a wildcard is found in Resources
        risky {
            stmt := version_document.Statement[_]
            contains_wildcard(stmt.Resource)
        }

        # Helper function to check if a string contains a wildcard
        contains_wildcard(value) {
            is_string(value)
            contains(value, "*")
        }

        contains_wildcard(value) {
            is_array(value)
            value[_] = element
            contains(element, "*")
        }
        EOF
        remediation_details = <<-EOF
          **Using AWS CLI**\n 1. This Follow the steps bellow
        EOF
}

resource "sysdig_secure_posture_control" "check_presence_of_internet_gateway"{
        name = "Custom - Internet Gateway - Internet Gateways are not allowed in this account."
        description = "Custom - Internet Gateway - Internet Gateways are not allowed in this account."
        resource_kind = "AWS_INTERNET_GATEWAY"
        severity = "High"
        rego = <<-EOF
        package sysdig

        default risky = true

        EOF
        remediation_details = <<-EOF
          **Using AWS CLI**\n 1. This Follow the steps bellow
        EOF
}
