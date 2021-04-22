data "terraform_remote_state" "micro" {
  backend = "remote"

  config = {
    organization = var.remote_state_organization
    workspaces = {
      name = var.remote_state_workspace_name
    }
  }
}
