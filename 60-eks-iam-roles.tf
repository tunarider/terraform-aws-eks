resource "aws_iam_role" "eks_cluster" {
  name = format("%sEKSCluster", title(data.terraform_remote_state.micro.outputs.project))

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : [
              "eks-fargate-pods.amazonaws.com",
              "eks.amazonaws.com"
            ]
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  tags = {
    Provisioner = "terraform"
    Project     = data.terraform_remote_state.micro.outputs.project
    Name        = format("%sEKSCluster", title(data.terraform_remote_state.micro.outputs.project))
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_main" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = data.aws_iam_policy.amazon_eks_cluster_policy.arn
}

resource "aws_iam_role_policy_attachment" "eks_cluster_vpc" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = data.aws_iam_policy.amazon_eks_vpc_resource_controller.arn
}

resource "aws_iam_role_policy_attachment" "eks_cluster_cloudwatch" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = aws_iam_policy.eks_cloudwatch_metrics.arn
}

resource "aws_iam_role_policy_attachment" "eks_cluster_elb" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = aws_iam_policy.eks_elb_permission.arn
}

resource "aws_iam_role" "eks_node" {
  name = format("%sEKSNode", title(data.terraform_remote_state.micro.outputs.project))

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  tags = {
    Provisioner = "terraform"
    Project     = data.terraform_remote_state.micro.outputs.project
    Name        = format("%sEKSNode", title(data.terraform_remote_state.micro.outputs.project))
  }
}

resource "aws_iam_role_policy_attachment" "eks_node_worker_node" {
  role       = aws_iam_role.eks_node.name
  policy_arn = data.aws_iam_policy.amazon_eks_worker_node_policy.arn
}

resource "aws_iam_role_policy_attachment" "eks_node_registry" {
  role       = aws_iam_role.eks_node.name
  policy_arn = data.aws_iam_policy.amazon_ec2_container_registry_read_only.arn
}

resource "aws_iam_role" "eks_cni" {
  name = format("%sEKSCNI", title(data.terraform_remote_state.micro.outputs.project))

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRoleWithWebIdentity"
          Condition = {
            StringEquals = {
              format("%s:aud", replace(aws_eks_cluster.main.identity.0.oidc.0.issuer, "https://", "")) = "sts.amazonaws.com"
              format("%s:sub", replace(aws_eks_cluster.main.identity.0.oidc.0.issuer, "https://", "")) = "system:serviceaccount:kube-system:aws-node"
            }
          }
          Effect = "Allow"
          Principal = {
            Federated = aws_iam_openid_connect_provider.eks.arn
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  tags = {
    Provisioner = "terraform"
    Project     = data.terraform_remote_state.micro.outputs.project
    Name        = format("%sEKSCNI", title(data.terraform_remote_state.micro.outputs.project))
  }
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  role       = aws_iam_role.eks_cni.name
  policy_arn = data.aws_iam_policy.amazon_eks_cni_policy.arn
}
