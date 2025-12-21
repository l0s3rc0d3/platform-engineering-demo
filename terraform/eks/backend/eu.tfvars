github_project             = "https://github.com/l0s3rc0d3/platform-engineering-demo"
sdlc_env                   = "demo"
aws_region                 = "eu-west-1"
vpc_name                   = "demo-vpc"
eks_name                   = "demo"
eks_version                = "1.34"
eks_controlplane_whitelist = ["XXX.XXX.XXX.XXX/32"]
vpc_eks_nodes_subnets      = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
eks_cluster_admins = [
  "arn:aws:iam::XXXXXXXXXXXX:role/XXXXXX"
]
eks_managed_node_groups = {
  "pe-team-demo" = {
    instance_types = ["t3.medium"]
    min_size       = 2
    max_size       = 2
    desired_size   = 2
  }
}