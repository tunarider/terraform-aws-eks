resource "aws_eks_addon" "vpc-cni" {
  addon_name               = "vpc-cni"
  cluster_name             = aws_eks_cluster.main.name
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = aws_iam_role.eks_cni.arn

  tags = {
    Provisioner = "terraform"
    Project     = data.terraform_remote_state.micro.outputs.project
    Name        = "vpc-cni"
  }
}
