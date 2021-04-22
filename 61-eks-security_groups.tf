resource "aws_security_group" "eks_cluster" {
  vpc_id = data.aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Provisioner = "terraform"
    Project     = data.terraform_remote_state.micro.outputs.project
    Name        = "eks-cluster"
  }
}
