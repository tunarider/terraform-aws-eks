data "aws_vpc" "main" {
  id = data.terraform_remote_state.micro.outputs.vpc_id
}

