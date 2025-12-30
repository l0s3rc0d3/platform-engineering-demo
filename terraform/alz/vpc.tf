module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"

  name = var.vpc_name
  cidr = var.vpc_primary_cidr

  azs = var.vpc_availability_zones

  public_subnets = var.vpc_public_subnets

  private_subnets = concat(var.vpc_private_subnets, var.vpc_eks_subnets)

  database_subnets                       = var.vpc_database_subnets
  create_database_subnet_route_table     = true
  create_database_nat_gateway_route      = false
  create_database_internet_gateway_route = false

  enable_nat_gateway = true
  # This is a demo so a single nat gateway is enough (cause underneath the natgateway is a secret ec2 instance and i want to reduce costs)
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  # Never used those, i need to play a little bit more to fully understand how it works
  # it seems related to loadbalacer service type and ingress resources that uses annotation to provision alb/nlb
  # and for karpenter 
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1",
    "karpenter.sh/discovery"          = var.vpc_karpenter_tag
  }
}