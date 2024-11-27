################################################################################
# Cluster
################################################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.10.0"

  cluster_name                   = local.name
  cluster_version                = "1.29"
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    initial = {
      ## $(pwd)/infrastructure/eks/.terraform/modules/eks/modules/eks-managed-node-group/variables.tf
      instance_types = ["t3.xlarge"]

      min_size     = 1
      max_size     = 1
      desired_size = 1

      # fix CVE-2017-18342      
      pre_bootstrap_user_data = <<-EOT
        rm /usr/lib64/python2.7/site-packages/PyYAML-3.10-py2.7.egg-info --force
        yum install -y pip
        pip install pyyaml
      EOT

      iam_role_additional_policies = {
        "ssm_managed_core"     = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        "s3_full_access"       = "arn:aws:iam::aws:policy/AmazonS3FullAccess",
        "cloudwatch_read_only" = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
        "ec2_full_access"      = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
        // required for SQS and CloudTrail Falco/Falcosidekick configuration
        "sqs_full_access"      = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
        // required for lambda access from Falco Talon
        "lambda_access"        = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
        "iam_access"           = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
      }
    }
  }

  # set clear dependencies
  depends_on = [module.vpc]
}

resource "aws_eks_access_entry" "admin_access" {
  cluster_name  = module.eks.cluster_name
  principal_arn = var.use_assumed_role ? tolist(data.aws_iam_roles.roles.arns)[0] : data.aws_caller_identity.current.arn
  type          = "STANDARD"
  depends_on    = [module.eks, module.vpc]
}

resource "aws_eks_access_policy_association" "admin_policy_association" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.use_assumed_role ? tolist(data.aws_iam_roles.roles.arns)[0] : data.aws_caller_identity.current.arn

  access_scope {
    type = "cluster"
  }

  depends_on = [module.eks, module.vpc, aws_eks_access_entry.admin_access]
}

################################################################################
# Supporting Resoruces
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

}

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.9.1"

  # eks_addons = {
  #   aws-ebs-csi-driver = {
  #     most_recent = true
  #   }
  # }

  eks_addons = {}

  cluster_name                        = module.eks.cluster_name
  cluster_endpoint                    = module.eks.cluster_endpoint
  cluster_version                     = module.eks.cluster_version
  oidc_provider_arn                   = module.eks.oidc_provider_arn
  enable_aws_load_balancer_controller = false
  enable_external_dns                 = false
  enable_external_secrets             = false

  depends_on = [module.eks]
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/sysdig-eks/vpc-id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "eks_worker_nodes_iam_role" {
  name  = "/sysdig-eks/worker-nodes-iam-role"
  type  = "String"
  value = module.eks.eks_managed_node_groups.initial.iam_role_name
}

output "eks_iam_role_name" {
  value       = module.eks.eks_managed_node_groups.initial.iam_role_name
  description = "value of the EKS managed worker nodes IAM role name"
}