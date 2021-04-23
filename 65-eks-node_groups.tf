resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${data.terraform_remote_state.micro.outputs.project}-public-node-group"

  ami_type      = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  disk_size     = 10
  instance_types = [
    "t3.large",
  ]
  labels = {
    "env"   = "prod"
    "scope" = "public"
  }
  node_role_arn = aws_iam_role.eks_node.arn
  subnet_ids    = data.terraform_remote_state.micro.outputs.public_subnet_ids

  remote_access {
    ec2_ssh_key = data.terraform_remote_state.micro.outputs.default_key_pair_name
    source_security_group_ids = [
      data.aws_security_group.default.id
    ]
  }

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_worker_node,
    aws_iam_role_policy_attachment.eks_node_registry,
    aws_iam_role_policy_attachment.eks_cni,
  ]

  tags = {
    Provisioner = "terraform"
    Project     = data.terraform_remote_state.micro.outputs.project
    Name        = "${data.terraform_remote_state.micro.outputs.project}-public-node-group"
  }
}

# resource "aws_eks_node_group" "private" {
#   cluster_name    = aws_eks_cluster.main.name
#   node_group_name = "${data.terraform_remote_state.micro.outputs.project}-private-node-group"

#   ami_type      = "AL2_x86_64"
#   capacity_type = "ON_DEMAND"
#   disk_size     = 10
#   instance_types = [
#     "t3.small",
#   ]
#   labels = {
#     "env"   = "prod"
#     "scope" = "private"
#   }
#   node_role_arn = aws_iam_role.eks_node.arn
#   subnet_ids    = data.terraform_remote_state.micro.outputs.private_subnet_ids

#   remote_access {
#     ec2_ssh_key = data.terraform_remote_state.micro.outputs.default_key_pair_name
#     source_security_group_ids = [
#       data.aws_security_group.default.id
#     ]
#   }

#   scaling_config {
#     desired_size = 2
#     max_size     = 4
#     min_size     = 2
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.eks_node_worker_node,
#     aws_iam_role_policy_attachment.eks_node_registry,
#     aws_iam_role_policy_attachment.eks_cni,
#   ]

#   tags = {
#     Provisioner = "terraform"
#     Project     = data.terraform_remote_state.micro.outputs.project
#     Name        = "${data.terraform_remote_state.micro.outputs.project}-private-node-group"
#   }
# }
