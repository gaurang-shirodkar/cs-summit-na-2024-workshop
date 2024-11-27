locals {
  name   = "sysdig"
  region = "us-east-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/IgorEulalio/sysdig-eks"
    Owner      = "Igor Eulalio"
  }
}