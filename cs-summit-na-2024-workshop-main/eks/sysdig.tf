# resource "helm_release" "sysdig_agent" {

#   name             = "sysdig-agent"
#   namespace        = "sysdig-agent"
#   repository       = "https://charts.sysdig.com"
#   chart            = "sysdig-deploy"
#   create_namespace = true
#   version          = "1.64.4"

#   values = [
#     templatefile("${path.module}/values/sysdig-values.yaml", {
#       cluster_name = local.name
#       access_key   = var.sysdig_accesskey
#       api_token    = var.sysdig_secure_api_token
#       secure_url   = var.sysdig_secure_url
#     }),
#   ]
# depends_on = [module.eks, module.vpc, aws_eks_access_entry.admin_access, aws_eks_access_policy_association.admin_policy_association ]
# }

resource "helm_release" "sysdig_shield" {

  name             = "sysdig-shield"
  namespace        = "sysdig-agent"
  repository       = "https://charts.sysdig.com"
  chart            = "shield"
  create_namespace = true
  version          = "0.1.13"

  values = [
    templatefile("${path.module}/values/sysdig-shield-values.yaml", {
      cluster_name = local.name
      access_key   = var.sysdig_accesskey
      region       = var.sysdig_region
    }),
  ]

  depends_on = [module.eks, module.vpc, aws_eks_access_entry.admin_access, aws_eks_access_policy_association.admin_policy_association]
}

# resource "helm_release" "registry_scanner" {
#   name             = "registry-scanner"
#   chart            = "registry-scanner"
#   repository       = "https://charts.sysdig.com"
#   create_namespace = true
#   namespace        = "sysdig-scanner" # Adjust as needed

#   values = [
#     templatefile("values/sysdig-scanner-values.yaml", {
#       secure_base_url  = var.sysdig_secure_url
#       secure_api_token = var.sysdig_secure_api_token
#       registry_url     = var.aws_registry_url
#       aws_region       = var.aws_region
#     })
#   ]
# depends_on = [module.eks, module.vpc, aws_eks_access_entry.admin_access, aws_eks_access_policy_association.admin_policy_association ]
# }
