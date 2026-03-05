locals {
  # it seems that is cannot tag subnets inside the module vpc, so i have to retreive their id
  # in order to tag them for eks usage
  eks_subnet_ids = [
    for i, cidr in module.vpc.private_subnets_cidr_blocks :
    module.vpc.private_subnets[i] if contains(var.vpc_eks_subnets, cidr)
  ]
}