data "aws_security_group" "default" {
  id = data.terraform_remote_state.micro.outputs.default_security_group_id
}
