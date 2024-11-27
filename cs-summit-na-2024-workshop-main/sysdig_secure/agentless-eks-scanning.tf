// Important: One single-region-eks block per region
module "single-region-eks" {
  count = var.deploy_eks_agentless_scanning ? 1 : 0
  source = "git::https://github.com/draios/terraform-aws-secure-for-cloud.git//modules/services/eks"

  // Important: Only a single single-region-eks module can have deploy_global_resources = true as that that is used to create the ECR role (we only need a single instance of the role)
  deploy_global_resources = true
  ecr_role_name           = "secure-eks-scanning-igm6" // Creates ECR role to pull images

  // eks_role_name is the same value as in CSPM module above
  // that role needs to follow the exact same name because it won't be created by this module
  eks_role_name    = "sysdig-secure-ie78" // CSPM role

  // Get trusted identity from your region, this is standard for all Sysdig roles
  trusted_identity = "arn:aws:iam::263844535661:role/gcp-us4-prod-usw1-secure-benchmark-assume-role"
  external_id      = "b770bf4ded9d1460b5723d6aefcffbf3"

  // Onboard selected (public) clusters only in us-east-1 region
  clusters = ["sysdig"]

  depends_on = [
    module.single-account-cspm
  ]
}