data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

data "aws_iam_roles" "roles" {
  name_regex  = "AWSReservedSSO_AWSAdministratorAccess_*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}