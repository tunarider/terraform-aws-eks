resource "aws_eks_cluster" "main" {
  name     = data.terraform_remote_state.micro.outputs.project
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.18"

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids = [
      aws_security_group.eks_cluster.id
    ]
    subnet_ids = concat(
      data.terraform_remote_state.micro.outputs.public_subnet_ids,
      # data.terraform_remote_state.micro.outputs.private_subnet_ids,
    )
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_main,
    aws_iam_role_policy_attachment.eks_cluster_vpc,
    aws_iam_role_policy_attachment.eks_cluster_cloudwatch,
  ]

  tags = {
    Provisioner = "terraform"
    Project     = data.terraform_remote_state.micro.outputs.project
    Name        = data.terraform_remote_state.micro.outputs.project
  }
}
